import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ValidateURLDynamicMacros)
import ValidateURLDynamicMacros

let testMacros: [String: Macro.Type] = [
    "stringify": ValidateURLDynamic.self,
]
#endif

final class ValidateURLDynamicTests: XCTestCase {
    func testMacro() throws {
        #if canImport(ValidateURLDynamicMacros)
        assertMacroExpansion(
                #"""
                #URL("https://www.avanderlee.com/\(Int.random())")
                """#,
                expandedSource: #"""

                """#,
                diagnostics: [
                    DiagnosticSpec(message: "#URL requires a static string literal", line: 1, column: 1)
                ],
                macros: testMacros
            )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    
    func testInvalidMacroError() {
        assertMacroExpansion(
                #"""
                #URL("https://www.avanderlee.com/\(Int.random())")
                """#,
                expandedSource: #"""

                """#,
                diagnostics: [
                    DiagnosticSpec(message: "#URL requires a static string literal", line: 1, column: 1)
                ],
                macros: testMacros
            )
    }

}
