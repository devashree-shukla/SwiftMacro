import ValidateURL

let result = #VerifyURL("https://www.google.com")

print("The value \(result) was produced by the code")

//let invalidURL = #URL("https:// hello invalid")

//Traiditional way:
//let swiftLeeBlogURL = {
//    guard let swiftLeeBlogURL = URL(string: "https://www.google.com") else {
//        /// Throw compiler error
//    }
//    return swiftLeeBlogURL
//}()
