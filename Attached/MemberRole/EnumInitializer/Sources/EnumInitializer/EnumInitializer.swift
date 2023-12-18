/// Defines a subset of the `Direction` enum
///
/// Generates two members:
///  - An initializer that converts a `Direction` to this type if the slope is
///    declared in this subset, otherwise returns `nil`
///  - A computed property `direction` to convert this type to a `Direction`
///
/// - Important: All enum cases declared in this macro must also exist in the
///              `Direction` enum.
@attached(member, names: named(init))
public macro EnumInitializer() = #externalMacro(module: "EnumInitializerMacros", type: "EnumInitializerMacro")
