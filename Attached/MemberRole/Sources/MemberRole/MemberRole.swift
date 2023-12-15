/// A macro that generates a logger function to let the
/// object log the issue within but only during debuging. For example,
///
///     @MemberRole
///     class DebugLogger {}
///
/// `produces a function`
///     func log(issue: String) {
///         #if DEBUG
///         print("In DebugLogger - \(issue)")
///         #endif
///     }
@attached(member, names: named(log(issue:)))
public macro MemberRole() = #externalMacro(module: "MemberRoleMacros", type: "MemberRoleMacro")
