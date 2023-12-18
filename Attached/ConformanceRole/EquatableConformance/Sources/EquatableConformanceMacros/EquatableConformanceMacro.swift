import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum EquatableConformanceMacro: ExtensionMacro {
  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let equatableExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Equatable {}")

    return [equatableExtension]
  }
}

@main
struct EquatableConformancePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EquatableConformanceMacro.self,
    ]
}
