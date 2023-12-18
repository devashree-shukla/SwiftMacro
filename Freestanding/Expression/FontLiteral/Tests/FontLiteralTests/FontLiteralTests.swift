import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(FontLiteralMacros)
import FontLiteralMacros

let testMacros: [String: Macro.Type] = [
    "FontLiteral": FontLiteralMacro.self,
]
#endif

final class FontLiteralMacroTests: XCTestCase {
  private let macros = ["fontLiteral": FontLiteralMacro.self]

  func testExpansionWithNamedArguments() {
    assertMacroExpansion(
      """
      #fontLiteral(name: "Comic Sans", size: 14, weight: .thin)
      """,
      expandedSource: """
        .init(fontLiteralName: "Comic Sans", size: 14, weight: .thin)
        """,
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }

  func testExpansionWithUnlabeledFirstArgument() {
    assertMacroExpansion(
      """
      #fontLiteral("Copperplate Gothic", size: 69, weight: .bold)
      """,
      expandedSource: """
        .init(fontLiteralName: "Copperplate Gothic", size: 69, weight: .bold)
        """,
      macros: macros,
      indentationWidth: .spaces(2)
    )
  }
}
