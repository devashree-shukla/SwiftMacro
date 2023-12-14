# SwiftMacro

This document contains all about Swift Macro new feature introduced in Swift 5.9 including basic concepts, examples, different real life use cases, testing macro processes. This repository demos all my takeaways after spending hours on various resources available on internet. 


## What is SwiftMacro ?

It is novel feature in Swift 5.9 that transforms source code at compile time, expands code before building the code and makes it available to use anywhere in code after type safety checks & syntactic validations. It is a most capable feature and enables [Meta Programming](https://en.wikipedia.org/wiki/Metaprogramming) in swift and a new way to write efficient swift code.


## Why SwiftMacro & What it does ? 

- Generate code at compile time
- Checks types of inputs & outputs at compile time -> Provides TypeSafety
- Validates syntax of inputs & output at compile time
- Avoids writing repeatative code by reusing same macro AST ([Abstract syntax tree](https://en.wikipedia.org/wiki/Abstract_syntax_tree))
- Improves code readability by simplifying code structures
- Optimizes code -> Provides Abstraction by hiding code behind macro
- Builds apps faster by avoiding duplications on macro expansion


## How it works ?

Expanding a macro is always an additive operation, adds code but never deletes or modifies existing code
If macro's implementation encounters an error, it is treated as compilation errors and stops writing incorrect or buggy macros

# Any macro have below phases

1. calling - # / @
2. declaration - public macro keywords, adds attributes with role, names, arbitary arguments
3. Implementation
4. Expansion
5. Debugging & Testing

**1. Types of Macros**

For both of below types only calling is different, else implementaiton and expansion process/approach is same

   **1. Freestanding**

   - A macro that is written standalone, appear on it's own and not attached to any declarations
   - Can produce a value or can perform some actions 
   - Calling this macro `#<macro-name>(<optional_arguments>)`
   - Uses lower camel case names
   - Like variables or functions
   
      **Examples:**
      
      `#function`
      
      `#warning("some_warning_message")`  

   **2. Attached**
   
   - Modifies declaration that they are attached to
   - They add code to the attached declaration 
   - Calling this macro `@<macro-name>(<optional_arguments>)`
   - Uses upper camel case names
   - Like structures or classes
   
      **Example:**
      ```
      @OptionSet<Int> 
      struct DemoStructure {
          private enum Options: Int {
              case zero
              case one
              case two
          }
      }
      ```


**2. Declaration -**

   - It contains name, parameter it takes, where it can be used, what kind of value it generates,
   - also provides information about the names of the symbols that the macro generates,
   - Includes arbitrary after the list of names, allowing the macro to generate declarations whose names aren’t known until you use the macro
  
   **Examples**
   ```
   @freestanding(expression)
   public macro line<T: ExpressibleByIntegerLiteral>() -> T = /* ... location of the macro implementation... */
   ```

   ```
   @attached(member, names: named(RawValue), named(rawValue), named(`init`), arbitrary)
   @attached(extension, conformances: OptionSet)
   public macro OptionSet<RawType>() = #externalMacro(module: "SwiftMacros", type: "OptionSetMacro")
   ```

**3. Implementation -** 

It contains the code that swift generates on macro expansion
   - Need to make 2 components :
     1. A type that performs macro expansion
     2. A library that declares macros to expose it as API
   - These parts are built separately from code that uses the macro, even if you’re developing the macro and its clients together, because the macro implementation runs as part of building the macro’s clients
   - Create a new macro using SPM
      1. run `swift package init --type macro` - this creates several files, including a template for a macro implementation and declaration
      2. 

**4. Expansion -**

   - Swift only shows macro defination when explicitly asked in Macro Expansion
   - Process:
     1. The compiler reads the code, creating an in-memory representation of the syntax.
     2. The compiler sends part of the in-memory representation to the macro implementation, which expands the macro.
     3. The compiler replaces the macro call with its expanded form.
     4. The compiler continues with compilation, using the expanded source code.
   - Uses `Abstract syntax tree` or `AST` representation of code in memory
   - Can pass same macro partial AST to each calls
   - A macro’s implementation operates only on the partial AST that it receives as its input, meaning a macro always expands the same way regardless of what code comes before and after it
   - This helps to understand macro easily and helps your code build faster because Swift can avoid expanding macros that haven’t changed
   - Swift helps macro authors avoid accidentally reading other input by restricting the code that implements macros:
     1. The AST passed to a macro implementation contains only the AST elements that represent the macro, not any of the code that comes before or after it.
     2. The macro implementation runs in a sandboxed environment that prevents it from accessing the file system or the network.
   - Runs in sandboxed environments - the macro’s author is responsible for not reading or modifying anything outside of the macro’s inputs
   - Can have several instances of the same macro and several calls to different macros, The compiler expands macros one at a time
   - For nested macros, outer macro is expanded first so that it can modify the inner macro

    
**5. Debugging & Testing -**



# Key points

- Macro declaration Will be always public because it is declared in other module place that where it can be called/used from
- Unlike other symbols, macros have seprate declarations & implementations
- Macros define macro roles - i.e. where it can be used, what kind of value it generates
- Every macro will have one or more roles - defined as part of [attributes](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes) like [@freestanding](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes#freestanding) / [@attached](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes)
  

# Use cases

- URL object
- Create struct
- Create init
- For enum
- Conformance to protocol (using attached)
- Create a new method (using attached)
- Nested macros
- Multiple macros & multiple calls


# Referances

**Github repos:**
- [ ] https://github.com/krzysztofzablocki/Swift-Macros
- [ ] DougGregor/swift-macro-examples - https://github.com/apple/swift-syntax/tree/main/Examples
- [ ] https://github.com/pointfreeco/swift-macro-testing
- [ ] https://github.com/apple/swift-syntax/tree/main/Examples/Sources/MacroExamples/Implementation

**Apple's:**

- [ ] Expand on swift macro video - https://developer.apple.com/videos/play/wwdc2023/10167/
- [x] Basic doc - **https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/**
- [ ] Write Swift Macro video - https://developer.apple.com/videos/play/wwdc2023/10166
- [ ] Applying macros - https://developer.apple.com/documentation/Swift/applying-macros
- [ ] Basics with good example - https://swiftylion.com/articles/swift-macros
- [ ] Basics - https://www.avanderlee.com/swift/macros/
- [ ] Basics - https://betterprogramming.pub/swift-macros-4f32e33ccf19
- [ ] Basics - https://engineering.traderepublic.com/get-ready-for-swift-macros-fe21d3867e02
- [ ] For Structure - https://betterprogramming.pub/use-swift-macros-to-initialize-a-structure-516728c5fb49
- [ ] For structure - https://github.com/HuangRunHua/wwdc23-code-notes/tree/main/struct-initial-macro
- [ ] Testing - https://github.com/pointfreeco/swift-macro-testing
- [ ] AST tool - https://swift-ast-explorer.com/
- [ ] Swift and tips video basics - https://www.youtube.com/watch?v=NGpM9-t9tgs
- [ ] Vincent basics - https://www.youtube.com/watch?v=jdfGhw8fqdM

**Additional Resources:**
- [x] Basics - https://medium.com/@aldo.vernando/swift-macros-faster-and-cleaner-33e4deead948
- [ ] Basics - https://byby.dev/swift-macros
- [ ] SwiftUI Preview macro - https://swiftwithmajid.com/2023/10/17/mastering-preview-macro-in-swift/
- [ ] API doc/example - https://github.com/ShenghaiWang/SwiftMacros
- [ ] Other language video - https://www.youtube.com/watch?v=phQKn6p6osQ
- [ ] macro for init - https://morioh.com/a/18dbd4c40db5/swift-macro-for-generating-initializers-initmacro





