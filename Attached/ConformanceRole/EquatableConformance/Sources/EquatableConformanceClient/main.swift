import EquatableConformance

@equatable
struct Person {
  let name: String
}

func checkName() {
  let tom = Person(name: "Tom")
  let jerry = Person(name: "Jerry")

  print("Has the person \(tom) the same name as the person \(jerry)?", tom == jerry ? "Yes." : "No.")
}
