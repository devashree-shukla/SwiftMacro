import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(StructureInitializerMacros)
import StructureInitializerMacros

let testMacros: [String: Macro.Type] = [
    "StructInit": StructInitMacro.self,
]
#endif

final class StructureInitializerTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @StructInit
            struct Book {
                var id: Int
                var title: String
                var subtitle: String
                var description: String
                var author: String
            }
            """,
            expandedSource:
            """
            
            struct Book {
                var id: Int
                var title: String
                var subtitle: String
                var description: String
                var author: String
                init(id: Int, title: String, subtitle: String, description: String, author: String) {
                    self.id = id
                    self.title = title
                    self.subtitle = subtitle
                    self.description = description
                    self.author = author
                }
            }
            """,
            macros: testMacros
        )
    }
}
