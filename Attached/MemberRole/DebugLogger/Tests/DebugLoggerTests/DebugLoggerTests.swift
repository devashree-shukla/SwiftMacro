import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(DebugLoggerMacros)
import DebugLoggerMacros

let testMacros: [String: Macro.Type] = [
    "DebugLoggerMacro": DebugLoggerMacro.self,
]
#endif

final class DebugLoggerTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @DebugLoggerMacro
            class Foo {
            }
            """,
            expandedSource: """
            class Foo {
                func log(issue: String) {
                    #if DEBUG
                    print(" In Foo - \\(issue) ")
                    #endif
                }
            }
            """,
            macros: testMacros
        )
    }
}
