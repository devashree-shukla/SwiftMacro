/// A macro that produces a structure object with default initializer. For example,
///
///     @StructInit()
///
///
/// produces a structure `(x + y, "x + y")`.
@attached(member, names: named(init))
public macro StructInit() = #externalMacro(module: "StructureInitializerMacros", type: "StructInitMacro")
