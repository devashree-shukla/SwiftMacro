import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(AsyncAwaitMacros)
import AsyncAwaitMacros

let testMacros: [String: Macro.Type] = [
    "AsyncAwait": AsyncAwaitMacro.self,
]
#endif

final class AsyncAwaitTests: XCTestCase {

    func testExpansionTransformsFunctionWithResultCompletionToAsyncThrows() {
        assertMacroExpansion(
          #"""
          @AddAsync
          func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
            completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
          }
          """#,
          expandedSource: #"""
            
            func c(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
              completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
            }

            func c(a: Int, for b: String, _ value: Double) async throws -> String {
              try await withCheckedThrowingContinuation { continuation in
                c(a: a, for: b, value) { returnValue in

                  switch returnValue {
                  case .success(let value):
                    continuation.resume(returning: value)
                  case .failure(let error):
                    continuation.resume(throwing: error)
                  }
                }
              }
            }
            """#,
          macros: testMacros,
          indentationWidth: .spaces(2)
        )
      }

      func testExpansionTransformsFunctionWithBoolCompletionToAsync() {
        assertMacroExpansion(
          """
          @AddAsync
          func d(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Bool) -> Void) -> Void {
            completionBlock(true)
          }
          """,
          expandedSource: """
            
            func d(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Bool) -> Void) -> Void {
              completionBlock(true)
            }

            func d(a: Int, for b: String, _ value: Double) async -> Bool {
              await withCheckedContinuation { continuation in
                d(a: a, for: b, value) { returnValue in

                  continuation.resume(returning: returnValue)
                }
              }
            }
            """,
          macros: testMacros,
          indentationWidth: .spaces(2)
        )
      }

      func testExpansionOnStoredPropertyEmitsError() {
        assertMacroExpansion(
          """
          struct Test {
            @AddAsync
            var name: String
          }
          """,
          expandedSource: """
            
            struct Test {
              var name: String
            }
            """,
          diagnostics: [
            DiagnosticSpec(
              message: "@addAsync only works on functions",
              line: 2,
              column: 3,
              severity: .error
            )
          ],
          macros: testMacros,
          indentationWidth: .spaces(2)
        )
      }

      func testExpansionOnAsyncFunctionEmitsError() {
        assertMacroExpansion(
          """
          struct Test {
            @AddAsync
            async func sayHello() {
            }
          }
          """,
          expandedSource: """
            
            struct Test {
              async func sayHello() {
              }
            }
            """,
          diagnostics: [
            DiagnosticSpec(
              message: "@addAsync requires an function that returns void",
              line: 2,
              column: 3,
              severity: .error
            )
          ],
          macros: testMacros,
          indentationWidth: .spaces(2)
        )
      }
    
}
