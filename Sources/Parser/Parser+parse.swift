extension Parser {
    /// Parses the input tokens that are coming from the Lexer
    /// You can pass a `debug=true` flag to print out the parsing steps.
    public func parse(tokens: [Token<Self.TokenTypes>], debug: Bool=false) throws -> Self.Output {
        let parser = ParserImpl<Self>.SLR1()
        return try parser.parse(tokens: tokens, debug: debug)
    }
    
    public func printParsingTable() {
        let parser = ParserImpl<Self>.SLR1()
        Swift.print(parser.parsingTable.debugDescription)
    }
}
