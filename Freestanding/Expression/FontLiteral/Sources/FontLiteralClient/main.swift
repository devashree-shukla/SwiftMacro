import FontLiteral

struct Font: ExpressibleByFontLiteral {
   init(fontLiteralName: String, size: Int, weight: FontLiteral.FontWeight) {
   }
 }

 let _: Font = #fontLiteral(name: "Comic Sans", size: 14, weight: .thin)
