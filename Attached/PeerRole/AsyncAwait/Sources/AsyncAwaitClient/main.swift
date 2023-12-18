import AsyncAwait

struct MyStruct {
    @AsyncAwait
    func one(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Result<String, Error>) -> Void) -> Void {
        completionBlock(.success("a: \(a), b: \(b), value: \(value)"))
    }
    
    @AsyncAwait
    func two(a: Int, for b: String, _ value: Double, completionBlock: @escaping (Bool) -> Void) -> Void {
        completionBlock(true)
    }
}

Task {
    let myStruct = MyStruct()
    _ = try? await myStruct.one(a: 5, for: "Swift", 20)
    
    _ = try? await myStruct.two(a: 10, for: "Macro", 40)
}
