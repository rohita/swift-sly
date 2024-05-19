/// A rule is defined by a string of the form `LHS -> RHS`.
///
/// The rule also define a production method which return a value that becomes associated with its LHS symbol elsewhere.
/// This is how values propagate within the grammar. The method is triggered when that grammar rule is recognized on the input.
/// As an argument, the method receives an array of symbol values "p", corresponding to the RHS of the rule. You can
/// access the symbol values by the index of its position in the RHS, e.g.
/// ```swift
/// Rule("E -> E + B") { p in
///    return p[0] + p[2]
/// }
/// ```
/// For terminals, the value is whatever was assigned to Token.value attribute in the lexer module.
/// For non-terminals, the input value is whatever was returned by the production defined for its rule.
public struct Rule<G : Grammar>: Hashable {
    let lhs : String
    let rhs : [String]
    let production: ([SymbolValue<G>]) -> G.Output
    
    init(lhs: String, rhs: [String]) {
        self.lhs = lhs
        self.rhs = rhs
        self.production = (\.first!.nonTermValue!)
    }
    
    public init(_ rule: String, production: @escaping ([SymbolValue<G>]) -> G.Output = (\.first!.nonTermValue!)) {
        let k = rule.split("->") // split LHS from RHS
        self.lhs = k[0].strip()
        let rhsSymbols = k[1].strip()
        self.rhs = rhsSymbols.split()
        self.production = production
    }
    
    // TODO: init with no production, but default production is AST
    
    
    public static func == (lhs: Rule<G>, rhs: Rule<G>) -> Bool {
        lhs.lhs == rhs.lhs && lhs.rhs == rhs.rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lhs)
        hasher.combine(rhs)
    }
}

extension Rule: CustomDebugStringConvertible {
    public var debugDescription: String {
        var sb = "\(lhs) ->"
        for r in rhs {
            sb.append(" \(r)")
        }
        return sb
    }
}
