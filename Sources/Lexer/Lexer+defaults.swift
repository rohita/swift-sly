/// Default Implementations
public extension Lexer {
    static var tokenRules: [TokenRegex<NoTokens>] { [] }
    static var literals: [String] { [] }
    static var ignore: String { "" }
}

public struct NoTokens: Tokenizable {
    public init?(rawValue: String) { nil }
    public var rawValue: String
}
