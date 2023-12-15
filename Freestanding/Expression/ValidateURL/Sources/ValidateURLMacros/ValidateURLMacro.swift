import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct ValidateURLMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        print(node.argumentList.map { $0.expression })
        guard let url = URL(string: "https://www.google.com") else {
            preconditionFailure(#"Invalid URL : '"https://www.google.com"'"#)
        }
        return url
    }
}

//Exporting the macro

@main
struct ValidateURLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ValidateURLMacro.self
    ]
}
