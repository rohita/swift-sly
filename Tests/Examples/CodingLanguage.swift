import SwiftSly

/// Example from:
/// http://blog.matthewcheok.com/writing-a-lexer-in-swift/
///
/// This lexer and grammer will recognize the following code snippet
/// ```
/// def foo(x, y)
///     x + y * 2 + (4 + 5) / 3
///
/// foo(3, 4)
/// ```
final class CodingLanguageLexer: Lexer {
    public enum TokenTypes: String, Tokenizable {
        case DEF, ID, NUM
    }
    
    static var literals = ["(", ")", ",", "+", "*"]
    static var ignore = "[ \t\n]"
    
    static var tokenRules: [TokenRegex<TokenTypes>] = [
        TokenRegex(.DEF,  pattern: "[a-zA-Z][a-zA-Z0-9]*") { token in
            token.value == "def" ? token : Token(TokenTypes.ID, value: token.value)
        },
        TokenRegex(.NUM, pattern: "[0-9.]+")
    ]
}
