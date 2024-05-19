extension Lexer {
    
    /// Lexer will scan through code and return a list
    /// of tokens that describe it. At this stage, it's not necessary
    /// to interpret the code in any way. We just want to identify different
    /// parts of the source and label them.
    public func tokenize(_ input: String) throws -> [Token<TokenTypes>] {
        var tokens = [Token<TokenTypes>]()
        var content = input
        
        while (content.count > 0) {
            var matched = false
            
            if !Self.ignore.isEmpty {
                if let match = content.firstMatch(of: try! Regex("^\(Self.ignore)")) {
                    let index = content.index(content.startIndex, offsetBy: match.0.count)
                    content = String(content.suffix(from: index))
                    continue
                }
            }
            
            for tokenRule in Self.tokenRules {
                if let match = content.firstMatch(of: try! Regex("^\(tokenRule.pattern)")) {
                    let token = Token<TokenTypes>(tokenRule.type, value: String(match.0))
                    if let token2 = tokenRule.overrideAction(token) {
                        tokens.append(token2)
                    }
                    
                    let index = content.index(content.startIndex, offsetBy: match.0.count)
                    content = String(content.suffix(from: index))
                    matched = true
                    break
                }
            }
            
            if !matched {
                let index = content.index(content.startIndex, offsetBy: 1)
                let literal = String(content.prefix(upTo: index))
                if Self.literals.contains(literal) {
                    tokens.append(Token(literal))
                    content = String(content.suffix(from: index))
                } else {
                    throw LexerError.unrecognizedToken(literal)
                }
            }
        }
        return tokens
    }
}
