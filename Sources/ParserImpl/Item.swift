struct Item<G: Parser>: Hashable {
    var rule: Rule<G>
    private let dotIndex : Int // represents the next position to parse
    
    init(rule: Rule<G>, dotIndex: Int = 0) {
        self.rule = rule
        self.dotIndex = dotIndex
    }
    
    var lhs: String {
        rule.lhs
    }
    
    var rhs: [String] {
        rule.rhs
    }
    
    var isHandle: Bool {
        dotIndex >= rhs.count
    }
    
    // represents the next symbol to parse
    var dotSymbol: String? {
        isHandle ? nil : rhs[dotIndex]
    }
    
    func advanceDot(after sym: String) -> Item? {
        dotSymbol.flatMap{ $0 == sym ?
            Item(rule: rule, dotIndex: dotIndex + 1) :
            nil
        }
    }
    
    func ruleEqual(to other: Rule<G>) -> Bool {
        self.rule == other
    }
}

extension Item: CustomDebugStringConvertible {
    var debugDescription: String {
        var sb = "\(lhs) -> "
        for i in 0..<rhs.count {
            if i == dotIndex {
                sb.append(". ")
            }
            sb.append("\(rhs[i]) ")
        }
        if rhs.count == dotIndex {
            sb.append(".")
        }
        return sb
    }
}
