import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct ValidateURL: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        print(node.argumentList.map { $0.expression })
        return "URL(string: \"https://www.avanderlee.com\")!"
    }
}

//Exporting the macro

@main
struct ValidateURLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ValidateURL.self
    ]
}
