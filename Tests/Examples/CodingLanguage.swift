import SwiftSly

/// Example from:
/// http://blog.matthewcheok.com/writing-a-lexer-in-swift/
/// http://blog.matthewcheok.com/writing-a-parser-in-swift/
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
        case DEF, ID, NUM, OP
    }
    
    static var literals = ["(", ")", ","]
    static var ignore = "[ \t\n]"
    
    static var tokenRules: [TokenRegex<TokenTypes>] = [
        TokenRegex(.DEF,  pattern: "[a-zA-Z][a-zA-Z0-9]*") { token in
            token.value == "def" ? token : Token(TokenTypes.ID, value: token.value)
        },
        TokenRegex(.NUM, pattern: "[0-9.]+"),
        TokenRegex(.OP, pattern: "(\\+|\\-|\\*|\\/)"),
    ]
}

final class CodingLanguageRules: Grammar {
    typealias TokenTypes = CodingLanguageLexer.TokenTypes
    
    static var rules: [Rule<CodingLanguageRules>] = [
        Rule("Expression -> PrimaryExpression OP Expression"),
        Rule("Expression -> PrimaryExpression"),
        Rule("PrimaryExpression -> ID"),
        Rule("PrimaryExpression -> NUM"),
        Rule("PrimaryExpression -> ( Expression )"),
    ]
}
