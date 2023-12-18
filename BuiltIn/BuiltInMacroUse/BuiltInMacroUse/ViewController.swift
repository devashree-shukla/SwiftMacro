//
//  ViewController.swift
//  BuiltInMacroUse
//
//  Created by devashree shukla on 15/12/23.
//

import UIKit

//#imageLiteral
//#colorLiteral
//#fontLiteral
//Codable
//Prpertywrappers
//willset, didset, lazy
//string interpolation
//result builder
//#line
//#warning

struct Article {
    let title: String
    let author: String
}

class ViewController: UIViewController {

    @IBOutlet weak var macro1: UIButton!
    
    let articles = [
        Article(title: "Swift Macros", author: "Antoine van der Lee"),
        Article(title: "What's new in Swift 5.9", author: "Paul Hudson"),
        Article(title: "Xcode 15: Automated accessibility audits", author: "Pol Piela")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func macro1Clicked(_ sender: Any) {
        //https://www.avanderlee.com/swift/predicate-macro-filtering-searching/ - Search / Filter
        
        let swiftLeeArticlesPredicate = #Predicate<Article> { article in
            article.title.contains("Swift") && article.author == "Antoine van der Lee"
        }
        
        printResult(predicate: swiftLeeArticlesPredicate)
        
        let swiftMacroArticle = #Predicate<Article> { article in
            /// A single condition for a specific title
            article.title == "Swift Macros"
        }
        printResult(predicate: swiftMacroArticle)

        /// Returning both articles written by Pol or Paul
        let paulArticle = #Predicate<Article> { article in
            article.author == "Paul Hudson" || article.author == "Pol Piela"
        }
        printResult(predicate: paulArticle)

        /// Returning all articles that don't have Swift in their title.
        let swiftArticle = #Predicate<Article> { article in
            !article.title.contains("swift")
        }
        printResult(predicate: swiftArticle)
    }
    
}

extension ViewController {
    
    private func printResult(predicate: Predicate<Article>) {
        do {
            let swiftLeeArticles = try articles
                .filter(predicate)
                .map(\.title)
            print(swiftLeeArticles)
        } catch {
            print("Error")
        }
    }
    
}
