import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(FunctionUniqueNameMacros)
import FunctionUniqueNameMacros

let testMacros: [String: Macro.Type] = [
    "FunctionUnique": FunctionUniqueMacro.self,
]
#endif

final class FunctionUniqueNameTests: XCTestCase {
    
    func testExpansionCreatesDeclarationWithUniqueFunction() {
        assertMacroExpansion(
          """
          #FunctionUniqueName()
          """,
          expandedSource: #"""
            class TestClass {
              func __macro_local_6uniquefMu_() {
              }
            }
            """#,
          macros: testMacros,
          indentationWidth: .spaces(2)
        )
    }
}
