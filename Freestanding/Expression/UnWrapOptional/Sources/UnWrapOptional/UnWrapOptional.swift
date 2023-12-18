
@freestanding(expression)
public macro unwrap<Wrapped>(expr: Wrapped?, message: String) -> Wrapped = #externalMacro(module: "UnWrapOptionalMacros", type: "UnWrapOptionalMacro")
