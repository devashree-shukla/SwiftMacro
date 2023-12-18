import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `#fontLiteral` macro, which is similar in spirit
/// to the built-in expressions `#colorLiteral`, `#imageLiteral`, etc., but in
/// a small macro.
public enum FontLiteralMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let argList = replaceFirstLabel(
            of: node.argumentList,
            with: "fontLiteralName"
        )
        return ".init(\(argList))"
    }
}

/// Replace the label of the first element in the tuple with the given
/// new label.
private func replaceFirstLabel(
    of tuple: LabeledExprListSyntax,
    with newLabel: String
) -> LabeledExprListSyntax {
    if tuple.isEmpty {
        return tuple
    }
    
    var tuple = tuple
    tuple[tuple.startIndex].label = .identifier(newLabel)
    tuple[tuple.startIndex].colon = .colonToken()
    return tuple
}

@main
struct FontLiteralPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FontLiteralMacro.self,
    ]
}
