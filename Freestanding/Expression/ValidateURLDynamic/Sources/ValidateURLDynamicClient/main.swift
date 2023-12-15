import ValidateURLDynamic

let result = #URL("https://www.avanderlee.com")
print("The value \(result) was produced by the code")

//let invalidURL = #URL("https:// hello invalid")

//Traiditional way:
//let swiftLeeBlogURL = {
//    guard let swiftLeeBlogURL = URL(string: "https://www.avanderlee.com") else {
//        /// Throw compiler error
//    }
//    return swiftLeeBlogURL
//}()
