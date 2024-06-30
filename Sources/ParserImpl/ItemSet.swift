struct ItemSet<G: Grammar>: Equatable {
    let items: [Item<G>]
    var transitions: [String: Int]
    
    init(items: [Item<G>], transitions: [String : Int] = [:]) {
        self.items = items
        self.transitions = transitions
    }
    
    var dotSymbols: [String] {
        items.compactMap{$0.dotSymbol}.dedupe()
    }
    
    var reduceItems: [Item<G>] {
        items.filter(\.isHandle)
    }
    
    func getItemsByAdvancingDot(after symbol: String) -> [Item<G>] {
        items.compactMap{$0.advanceDot(after: symbol)}
    }
    
    static func == (lhs: ItemSet, rhs: ItemSet) -> Bool {
        lhs.items == rhs.items
    }
}

extension ItemSet: CustomDebugStringConvertible {
    var debugDescription: String {
        var sb = ""
        for item in items {
            sb.append("\(item)\n")
        }
        return sb
    }
}
