import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct StructClassInitializerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        InitMacro.self,
    ]
}
