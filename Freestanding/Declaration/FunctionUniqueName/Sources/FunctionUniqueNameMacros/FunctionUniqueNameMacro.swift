import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `stringify` macro, which generates unique name for function
public enum FunctionUniqueMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let name = context.makeUniqueName("unique")
        return [
      """
      class TestClass {
        func \(name)() {}
      }
      """
        ]
    }
}

@main
struct FunctionUniqueNamePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FunctionUniqueMacro.self,
    ]
}
