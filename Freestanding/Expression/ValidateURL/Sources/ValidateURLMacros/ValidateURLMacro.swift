import SwiftCompilerPlugin
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Creates a non-optional URL from a static string. The string is checked to
/// be valid during compile time.
///

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

public enum URLMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {
      guard let argument = node.argumentList.first?.expression,
      let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
      segments.count == 1,
      case .stringSegment(let literalSegment)? = segments.first
    else {
          throw URLMacroError.requiresStaticStringLiteral
    }

    guard let str = URL(string: literalSegment.content.text) else {
        throw URLMacroError.malformedURL(urlString: argument.description)
    }

    return "URL(string: \(argument))!"
  }
}

@main
struct ValidateURLPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
    ]
}
