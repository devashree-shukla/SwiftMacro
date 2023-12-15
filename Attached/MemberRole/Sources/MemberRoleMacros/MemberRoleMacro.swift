import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum DebugLoggerError: CustomStringConvertible, Error {
    case notCorrectType
    var description: String {
        switch self {
        case .notCorrectType: return "@DebugLogger can only be applied to a class & struct"
        }
    }
}

public struct MemberRoleMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        // TODO: add type check for other DeclSyntax
        let identifier: TokenSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            identifier = classDecl.name
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            identifier = structDecl.name
        } else {
            throw DebugLoggerError.notCorrectType
        }

        let printFunc = try FunctionDeclSyntax("func log(issue: String)") {
            StmtSyntax(stringLiteral:
                """
                #if DEBUG
                print(\"In \(identifier.text) - \\(issue)\")
                #endif
                """
            )
        }

        return [
            DeclSyntax(printFunc)
        ]
    }
}

@main
struct MemberRolePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MemberRoleMacro.self,
    ]
}
