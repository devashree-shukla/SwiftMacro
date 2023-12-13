# SwiftMacro
All about Swift Macro new feature introduced in Swift 5.9, details, examples, use cases, test cases

My takeaways on Macros in Swift are as below

# What is SwiftMacro ?

It is novel feature in Swift 5.9 that transforms source code at compile time, expands code before building the code and makes it available to use anywhere in code after type safety checks & syntactic validations

# Why SwiftMacro & What it does ? 

Generate code at compile time
Checks types -> TypeSafety
Validates syntax of inputs/output
Avoids writing repeatative code

# How it works ?

Expanding a macro is always an additive operation, adds code but never deletes or modifies existing code
If macro's implementation encounters an error, it is treated as compilation errors and stops writing incorrect or buggy macros

Any macro have 2 phases :
1. implementation
2. Expansion

# Key points

- Will be always public

# Types of Macros 

for both of below only calling is different, else implementaiton and expansion process/approach is same

**1. Freestanding**
   - A macro that is written standalone, appear on it's own and not attached to any declarations
   - Calling this macro '#<macro-name>(<arguments>)'

**2. Attached**
   - Modifies declaration to which it is attached to



calling
declaration
Expansion
Implementation
Debugging
Testing

Use cases:
- URL object
- Create struct
- Create init
- For enum


Referances:

https://github.com/krzysztofzablocki/Swift-Macros
https://github.com/pointfreeco/swift-macro-testing
https://github.com/apple/swift-syntax/tree/main/Examples/Sources/MacroExamples/Implementation

https://developer.apple.com/videos/play/wwdc2023/10167/
https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/
https://developer.apple.com/videos/play/wwdc2023/10166
https://developer.apple.com/documentation/Swift/applying-macros

https://betterprogramming.pub/use-swift-macros-to-initialize-a-structure-516728c5fb49
https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/struct-initial-macro





