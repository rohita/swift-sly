/// The Lexer class is used to break input text into a collection of tokens
/// specified by a collection of regular expression rules.
///
/// In the lexical analysis phase, we simply try to break up the input
/// (source code) into the small units called lexemes. These units carry
/// specific meaning which we can categorise into groups of tokens.
///
/// ## Example
/// ```swift
/// final class CalcLexer: Lexer {
///     public enum TokenTypes: String, Tokenizable {
///         case Define, Identifier, Number
///     }
///
///     static var literals = ["(", ")", ",", "+", "*"]
///     static var ignore = "[ \t\n]"
///
///     static var tokenRules: [TokenRegex<TokenTypes>] = [
///         TokenRegex(.Define,  pattern: "[a-zA-Z][a-zA-Z0-9]*") { token in
///             token.value == "def" 
///                 ? token
///                 : Token(TokenTypes.Identifier, value: token.value)
///         },
///         TokenRegex(.Number, pattern: "[0-9.]+")
///     ]
/// }
/// ```
public protocol Lexer {

    /// TokenType maps to Grammer terminals.
    associatedtype TokenTypes: Tokenizable

    /// For each token, we need a regular expression capable of matching its
    /// corresponding lexeme. Then, we need to generate the token that matches
    /// the regex. We can put this all together rather concisely as an array of TokenRules.
    static var tokenRules: [TokenRegex<TokenTypes>] { get }
    
    /// A literal character is a single character that is returned “as is” when encountered by the lexer.
    /// Literals are checked after all of the defined regular expression rules. Thus, if a rule starts with
    /// one of the literal characters, it will always take precedence. When a literal token is returned,
    /// both its type and value attributes are set to the character itself. For example, '+'.
    ///
    /// Literals are limited to a single character. Thus, it is not legal to specify literal such as <= or \==.
    /// For this, use the normal lexing rules (e.g., define a rule such as LE = "<=").
    static var literals: [String] { get }
    
    /**
     The special ignore specification is reserved for single characters that should be completely
     ignored between tokens in the input stream. Usually this is used to skip over whitespace
     and other padding between the tokens that you actually want to parse.
     */
    static var ignore: String { get }
}
