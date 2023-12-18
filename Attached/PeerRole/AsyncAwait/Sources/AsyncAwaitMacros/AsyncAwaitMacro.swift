import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension SyntaxCollection {
    mutating func removeLast() {
        self.remove(at: self.index(before: self.endIndex))
    }
}

enum AsyncAwaitError: CustomStringConvertible, Error {
    case onlyonFunctions
    case requiresNonAsyncFunction
    case requiresFunctionThatreturnsVoid
    case requiresFunctionWithCompletionHandlerAsLastParam
    case requiresFunctionWithCompletionHandlerReturningVoid
    
    var description: String {
        switch self {
        case .onlyonFunctions:
            return "@AsyncAwait only works on functions"
        case .requiresNonAsyncFunction:
            return "@AsyncAwait requires an non async function"
        case .requiresFunctionThatreturnsVoid:
            return "@AsyncAwait requires an function that returns void"
        case .requiresFunctionWithCompletionHandlerAsLastParam:
            return "@AsyncAwait requires an function that has a completion handler as last parameter"
        case .requiresFunctionWithCompletionHandlerReturningVoid:
            return "@AsyncAwait requires an function that has a completion handler that returns Void"
        }
    }
}

public struct AsyncAwaitMacro: PeerMacro {
    public static func expansion<
        Context: MacroExpansionContext,
        Declaration: DeclSyntaxProtocol
    >(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        
        // Only on functions at the moment.
        guard var funcDecl = declaration.as(FunctionDeclSyntax.self) else {
            throw AsyncAwaitError.onlyonFunctions
        }
        
        // This only makes sense for non async functions.
        if funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil {
            throw AsyncAwaitError.requiresNonAsyncFunction
        }
        
        // This only makes sense void functions
        if funcDecl.signature.returnClause?.type.as(IdentifierTypeSyntax.self)?.name.text != "Void" {
            throw AsyncAwaitError.requiresFunctionThatreturnsVoid
        }
        
        // Requires a completion handler block as last parameter
        guard let completionHandlerParameterAttribute = funcDecl.signature.parameterClause.parameters.last?.type.as(AttributedTypeSyntax.self),
              let completionHandlerParameter = completionHandlerParameterAttribute.baseType.as(FunctionTypeSyntax.self)
        else {
            throw AsyncAwaitError.requiresFunctionWithCompletionHandlerAsLastParam
        }
        
        // Completion handler needs to return Void
        if completionHandlerParameter.returnClause.type.as(IdentifierTypeSyntax.self)?.name.text != "Void" {
            throw AsyncAwaitError.requiresFunctionWithCompletionHandlerReturningVoid
        }
        
        let returnType = completionHandlerParameter.parameters.first?.type
        
        let isResultReturn = returnType?.children(viewMode: .all).first?.description == "Result"
        let successReturnType = isResultReturn ? returnType!.as(IdentifierTypeSyntax.self)!.genericArgumentClause?.arguments.first!.argument : returnType
        
        // Remove completionHandler and comma from the previous parameter
        var newParameterList = funcDecl.signature.parameterClause.parameters
        newParameterList.removeLast()
        var newParameterListLastParameter = newParameterList.last!
        newParameterList.removeLast()
        newParameterListLastParameter.trailingTrivia = []
        newParameterListLastParameter.trailingComma = nil
        newParameterList.append(newParameterListLastParameter)
        
        // Drop the @addAsync attribute from the new declaration.
        let newAttributeList = funcDecl.attributes.filter {
            guard case let .attribute(attribute) = $0,
                  let attributeType = attribute.attributeName.as(IdentifierTypeSyntax.self),
                  let nodeType = node.attributeName.as(IdentifierTypeSyntax.self)
            else {
                return true
            }
            
            return attributeType.name.text != nodeType.name.text
        }
        
        let callArguments: [String] = newParameterList.map { param in
            let argName = param.secondName ?? param.firstName
            
            let paramName = param.firstName
            if paramName.text != "_" {
                return "\(paramName.text): \(argName.text)"
            }
            
            return "\(argName.text)"
        }
        
        let switchBody: ExprSyntax =
      """
            switch returnValue {
            case .success(let value):
              continuation.resume(returning: value)
            case .failure(let error):
              continuation.resume(throwing: error)
            }
      """
        
        let newBody: ExprSyntax =
      """
      
        \(raw: isResultReturn ? "try await withCheckedThrowingContinuation { continuation in" : "await withCheckedContinuation { continuation in")
          \(raw: funcDecl.name)(\(raw: callArguments.joined(separator: ", "))) { \(raw: returnType != nil ? "returnValue in" : "")
      
      \(raw: isResultReturn ? switchBody : "continuation.resume(returning: \(raw: returnType != nil ? "returnValue" : "()"))")
          }
        }
      
      """
        
        // add async
        funcDecl.signature.effectSpecifiers = FunctionEffectSpecifiersSyntax(
            leadingTrivia: .space,
            asyncSpecifier: .keyword(.async),
            throwsSpecifier: .keyword(.throws),
            trailingTrivia: nil)
        
        
        
//        FunctionEffectSpecifiersSyntax(
//            leadingTrivia: .space,
//            asyncSpecifier: .keyword(.async),
//            throwsClause: isResultReturn ? ThrowsClauseSyntax(throwsSpecifier: .keyword(.throws)) : nil
//        )
        
        
        // add result type
        if let successReturnType {
            funcDecl.signature.returnClause = ReturnClauseSyntax(leadingTrivia: .space, type: successReturnType.with(\.leadingTrivia, .space))
        } else {
            funcDecl.signature.returnClause = nil
        }
        
        // drop completion handler
        funcDecl.signature.parameterClause.parameters = newParameterList
        funcDecl.signature.parameterClause.trailingTrivia = []
        
        funcDecl.body = CodeBlockSyntax(
            leftBrace: .leftBraceToken(leadingTrivia: .space),
            statements: CodeBlockItemListSyntax(
                [CodeBlockItemSyntax(item: .expr(newBody))]
            ),
            rightBrace: .rightBraceToken(leadingTrivia: .newline)
        )
        
        funcDecl.attributes = newAttributeList
        
        funcDecl.leadingTrivia = .newlines(2)
        
        return [DeclSyntax(funcDecl)]
    }
}
