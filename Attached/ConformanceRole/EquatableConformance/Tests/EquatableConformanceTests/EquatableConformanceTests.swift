import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EquatableConformanceMacros)
import EquatableConformanceMacros

let testMacros: [String: Macro.Type] = [
    "EquatableConformance": EquatableConformanceMacro.self,
]
#endif

final class EquatableConformanceTests: XCTestCase {
    func testMacro() throws {
        assertMacroExpansion(
              """
              @equatable
              final public class Message {
                let text: String
                let sender: String
              }
              """,
              expandedSource: """
                final public class Message {
                let text: String
                let sender: String
                }
                extension Message: Equatable {
                }
                """,
              macros: testMacros,
              indentationWidth: .spaces(2)
        )
    }
    
}
