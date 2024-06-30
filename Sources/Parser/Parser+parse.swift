extension Parser {
    public func parse(tokens: [Token<Self.TokenTypes>]) throws -> Self.Output {
        let parser = ParserImpl<Self>.SLR1()
        return try parser.parse(tokens: tokens)
    }
    
    public func printParsingTable() {
        let parser = ParserImpl<Self>.SLR1()
        Swift.print(parser.debugDescription)
    }
}
