import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(ValidateURLMacros)
import ValidateURLMacros

let testMacros: [String: Macro.Type] = [
    "ValidateURL": ValidateURLMacro.self,
]
#endif

final class ValidateURLTests: XCTestCase {
    func testMacro() throws {
        #if canImport(ValidateURLMacros)
        assertMacroExpansion(
                #"""
                #VerifyURL("https://www.google.com/\(Int.random())")
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

}
