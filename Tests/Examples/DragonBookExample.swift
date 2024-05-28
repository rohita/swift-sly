import SwiftSly

/// Example from the "Dragon Book"
/// Compilers: Principles, Techniques, and Tools
///     By: Aho, Sethi, Ullman
/// Also see:
///     https://www.geeksforgeeks.org/compiler-design-slr1-parser-using-python/
final class DragonBookLexer: Lexer {
    public enum TokenTypes: String, Tokenizable {
        case id
    }
    
    static var literals = ["+", "*", "(", ")"]
    static var ignore = "[ \t\n]"
    
    static var tokenRules: [TokenRegex<TokenTypes>] = [
        TokenRegex(.id,  pattern: "[a-zA-Z][a-zA-Z0-9]*")
    ]
}

final class DragonBookGrammar: Grammar {
    typealias TokenTypes = DragonBookLexer.TokenTypes
    
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
