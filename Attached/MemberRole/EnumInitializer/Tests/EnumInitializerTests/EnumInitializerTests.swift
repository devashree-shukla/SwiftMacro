import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumInitializerMacros)
import EnumInitializerMacros

let testMacros: [String: Macro.Type] = [
    "EnumInitializer": EnumInitializerMacro.self,
]
#endif

final class EnumInitializerTests: XCTestCase {
    func testMacro() throws {
        #if canImport(EnumInitializerMacros)
        assertMacroExpansion(
            """
            @EnumInitializer
            enum Direction {
                case north
                case south
                case east
                case west
            }
            """,
            expandedSource: """
            
            enum Direction {
                case north
                case south
                case east
                case west
            
                init?(_ direction: Direction) {
                    switch direction {
                    case .north:
                        self = .north
                    case .south:
                        self = .south
                    case .east:
                        self = .east
                    case .west:
                        self = .west
                    }
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testSlopeSubsetOnStruct() throws {
        assertMacroExpansion(
            """
            @EnumInitializer
            struct Direction {
            }
            """,
            expandedSource: """

            struct Direction {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "@EnumInitializer can only be applied to an enum", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    
}
