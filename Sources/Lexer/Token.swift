/// Representation of a single token, which the lexer recognizes, and parser parses.
///
/// The first step of parsing is to break the text into tokens where each token has a type and value.
///
/// For example, we have the following text:
/// ```
/// def foo(x, y) x + y * 2
/// ```
///
/// The tokens for the above might be described by token types and literals:
/// ```swift
/// public enum TokenTypes: String, Tokenizable {
///     case DEF, ID, NUM
/// }
///
/// static var literals = ["(", ")", ",", "+", "*"]
/// ```
///
/// And so the tokens identified by the lexer would be list of (name,value) pairs:
/// ```swift
/// [('DEF','def'), ('ID','foo'), ('(','('), 
///  ('ID','x'), (',',','), ('ID','y'),
///  (')',')'), ('ID','x'), ('+','+'),
///  ('ID','y'), ('*','*'), ('NUM','2')]
/// ```
/// Token name can be `Tokenizable` or literals. For literals, the name and value
/// of the token is same.
public struct Token<T: Tokenizable>: Hashable {
    public let name: String
    public let value: String
    public let isLiteral: Bool
    
    public init(_ type: T, value: String) {
        self.name = type.rawValue
        self.value = value
        self.isLiteral = false
    }
    
    public init(_ type: T) {
        self.name = type.rawValue
        self.value = type.rawValue
        self.isLiteral = false
    }
    
    public init(_ literal: String) {
        self.name = literal
        self.value = literal
        self.isLiteral = true
    }
}

extension Token: CustomDebugStringConvertible {
    public var debugDescription: String {
        isLiteral ? "Literal(\"\(value)\")" : "\(name)(\"\(value)\")"
    }
}
