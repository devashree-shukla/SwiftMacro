
// MARK: - Func Unique

@freestanding(declaration, names: named(TestClass))
public macro FunctionUniqueName() = #externalMacro(module: "FunctionUniqueNameMacros", type: "FunctionUniqueMacro")
