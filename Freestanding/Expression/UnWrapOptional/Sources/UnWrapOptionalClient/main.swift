import UnWrapOptional
import Foundation

let stringImage = "https://images.freeimages.com/images/large-previews/f2c/effi-1-1366221.jpg"

let url = URL(string: stringImage)
print(url)

let unwrappedurl = #unwrap(expr: URL(string: stringImage), message: "URL is nil")
print(unwrappedurl)
