// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

/// A macro that produces an unwrapped valid URL in case of a valid input URL
/// For example,
///
///     #URL("https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/")
///
/// produces an unwrapped `URL` if the URL is valid. Otherwise, it emits a compile-time error.
@freestanding(expression)
public macro URL(_ stringLiteral: String) -> URL = #externalMacro(module: "ValidateURLDynamicMacros", type: "ValidateURLDynamic")
