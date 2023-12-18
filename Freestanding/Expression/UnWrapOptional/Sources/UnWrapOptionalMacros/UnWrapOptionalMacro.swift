import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct UnWrapOptionalMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return argument
    }
}

@main
struct UnWrapOptionalPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        UnWrapOptionalMacro.self,
    ]
}
