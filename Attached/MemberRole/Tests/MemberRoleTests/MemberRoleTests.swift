import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(MemberRoleMacros)
import MemberRoleMacros

let testMacros: [String: Macro.Type] = [
    "MemberRoleMacro": MemberRoleMacro.self,
]
#endif

final class DebugLoggerTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @MemberRoleMacro
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
