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
public struct Rule<G : Parser>: Hashable {
    let lhs : String
    let rhs : [String]
    let production: ([SymbolValue<G>]) -> G.Output
    
    init(lhs: String, rhs: [String], production: @escaping ([SymbolValue<G>]) -> G.Output) {
        self.lhs = lhs
        self.rhs = rhs
        self.production = production
    }
    
    public init(_ rule: String, production: @escaping ([SymbolValue<G>]) -> G.Output) {
        let splitRule = Self.splitRule(rule)
        self.init(lhs: splitRule.lhs, rhs: splitRule.rhs, production: production)
    }
    
    public static func == (lhs: Rule<G>, rhs: Rule<G>) -> Bool {
        lhs.lhs == rhs.lhs && lhs.rhs == rhs.rhs
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lhs)
        hasher.combine(rhs)
    }
    
    static func splitRule(_ rule: String) -> (lhs: String, rhs: [String]) {
        let k = rule.split("->") // split LHS from RHS
        let lhs = k[0].strip()
        let rhsSymbols = k[1].strip()
        let rhs = rhsSymbols.split()
        return (lhs, rhs)
    }
}

extension Rule where G.Output: AbstractSyntaxTree {
    /// Init with no production, defaults to AST
    public init(_ rule: String) {
        let splitRule = Self.splitRule(rule)
        
        let astProduction: ([SymbolValue<G>]) -> NonTerminalNode = { p in
            var children: [AbstractSyntaxTree] = []
            for (i, sym) in p.enumerated() {
                if let term = sym.termValue {
                    children.append(TerminalNode(symbolName: splitRule.rhs[i], value: term))
                } else if let nonTerm = sym.nonTermValue {
                    children.append(NonTerminalNode(symbolName: splitRule.rhs[i], children: [nonTerm] as! [any AbstractSyntaxTree]))
                }
            }
            return NonTerminalNode(symbolName: splitRule.lhs, children: children)
        }
        
        self.init(lhs: splitRule.lhs, rhs: splitRule.rhs, production: astProduction as! ([SymbolValue<G>]) -> G.Output)
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
