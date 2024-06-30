extension Grammar {
    static var startSymbol: String {
        rules[0].lhs // The very first grammar rule defines the top of the parse
    }
    
    static var terminals: [String] {
        rules.flatMap(\.rhs).filter{!nonTerminals.contains($0)}.dedupe()
    }
    
    static var nonTerminals: [String] {
        rules.map(\.lhs).dedupe()
    }
    
    public func parse(tokens: [Token<Self.TokenTypes>]) throws -> Self.Output {
        let parser = ParserImpl<Self>.SLR1()
        return try parser.parse(tokens: tokens)
    }
    
    public func printParsingTable() {
        let parser = ParserImpl<Self>.SLR1()
        Swift.print(parser.debugDescription)
    }
}
