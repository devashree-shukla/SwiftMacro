import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(UnWrapOptionalMacros)
import UnWrapOptionalMacros

let testMacros: [String: Macro.Type] = [
    "UnWrapOptional": UnWrapOptionalMacro.self,
]
#endif

final class UnWrapOptionalTests: XCTestCase {
    func testMacro() throws {
//        #if canImport(UnWrapOptionalMacros)
//        assertMacroExpansion(
//            """
//            let aNumber: Int?
//            let image = #unwrap(aNumber, message: "Image is not downloadable")
//            """,
//            expandedSource: """
//            let aNumber: Int?
//            let image = aNumber
//            """,
//            diagnostics: DiagnosticSpec(message: "No image", line: 1, column: 1),
//            macros: testMacros
//        )
//        #else
//        throw XCTSkip("macros are only supported when running tests for the host platform")
//        #endif
    }

}


//Unwrap any value - generic macro
//freestanding decl - makeArrayND
//peer - Asnc concurrency for completion handler
//accessor - to properties getters/setters
//memberattribute -
//member -
//conformance - type or extension
