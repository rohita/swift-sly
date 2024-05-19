import SwiftSly

/// Example from the "Dragon Book"
/// Compilers: Principles, Techniques, and Tools
///     By: Aho, Sethi, Ullman
/// Also see:
///     https://www.geeksforgeeks.org/compiler-design-slr1-parser-using-python/
final class DragonBookGrammar: Grammar {
    typealias Output = String
    
    enum TokenTypes: String, Tokenizable {
        case id
    }
    
    static var rules: [Rule<DragonBookGrammar>] {
        [Rule("E -> E + T"),
         Rule("E -> T"),
         Rule("T -> T * F"),
         Rule("T -> F"),
         Rule("F -> ( E )"),
         Rule("F -> id"),
        ]
    }
}
