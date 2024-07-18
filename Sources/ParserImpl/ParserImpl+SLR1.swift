extension ParserImpl {
    static func SLR1() -> Self {
        var table = ItemSetTable<G>()
        let I0 = table.computeClosure(using: [Item(rule: table.allRulesList[0])])
        table.generateStates(startingState: I0)
        table.createParseTable()
        return ParserImpl(parsingTable: table)
    }
}
