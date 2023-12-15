import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum URLMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case malformedURL(urlString: String)

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#URL requires a static string literal"
        case .malformedURL(let urlString):
            return "The input URL is malformed: \(urlString)"
        }
    }
}

public struct ValidateURLDynamic: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
                    /// 1. Grab the first (and only) Macro argument.
                    let argument = node.argumentList.first?.expression,
                    /// 2. Ensure the argument contains of a single String literal segment.
                    let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
                    segments.count == 1,
                    /// 3. Grab the actual String literal segment.
                    case .stringSegment(let literalSegment)? = segments.first
                else {
                    throw URLMacroError.requiresStaticStringLiteral
                }

                /// 4. Validate whether the String literal matches a valid URL structure.
                guard let _ = URL(string: literalSegment.content.text) else {
                    throw URLMacroError.malformedURL(urlString: "\(argument)")
                }

                return "URL(\(argument))!"
    }
}

//Exporting the macro

@main
struct ValidateURLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ValidateURLDynamic.self,
    ]
}
