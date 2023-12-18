import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum EnumInitializerError: CustomStringConvertible, Error {
    case onlyAllowedToEnum
    
    var description: String {
        switch self {
        case .onlyAllowedToEnum: return "@EnumInitializer can only be applied to an enum"
        }
    }
}


public struct EnumInitializerMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        
        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw EnumInitializerError.onlyAllowedToEnum
        }
        let members = enumDecl.memberBlock.members
        let caseDecls = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecls.flatMap { $0.elements }
        
        let initializer = try InitializerDeclSyntax("init?(_ direction: Direction)") {
            try SwitchExprSyntax("switch direction") {
                for element in elements {
                    SwitchCaseSyntax(
                    """
                    case .\(element.name):
                        self = .\(element.name)
                    """
                    )
                }
                //This default case can be optional to add, not needed in all the enum cases
                //SwitchCaseSyntax("default: return nil")
            }
        }
        return [DeclSyntax(initializer)]
    }
}

@main
struct EnumInitializerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EnumInitializerMacro.self,
    ]
}
