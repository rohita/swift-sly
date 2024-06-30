struct ItemSetTable<G: Parser> {
    let EPSILON = "#"
    let allRulesList: [Rule<G>]
    var states: [Int: ItemSet<G>]
    var actionTable: [Int: [String: Action<G>]]
    var gotoTable: [Int: [String: Int]]
    
    init() {
        let augmentedRule = Rule<G>(lhs: G.startSymbol + "'", rhs: [G.startSymbol], production: (\.first!.nonTermValue!))
        
        self.allRulesList = [augmentedRule] + G.rules
        self.states = [:]
        self.actionTable = [:]
        self.gotoTable = [:]
    }
    
    func computeClosure(using kernelItems: [Item<G>]) -> ItemSet<G> {
        var runningClosureSet = kernelItems
        var prevLen = -1
        while prevLen != runningClosureSet.count {
            prevLen = runningClosureSet.count
            let dotSymbols = runningClosureSet.compactMap{$0.dotSymbol}.dedupe()
            let newClosureRules = allRulesList.filter{dotSymbols.contains($0.lhs)}
            runningClosureSet.append(contentsOf: newClosureRules.map{Item(rule: $0)})
            runningClosureSet = runningClosureSet.dedupe()
        }

        return ItemSet(items: runningClosureSet)
    }
    
    mutating func generateStates(startingState: ItemSet<G>) {
        states = [0: startingState]
        
        var prevLen = -1
        var visited: Set<Int> = []
        
        // run loop while new states are getting added
        while (states.count != prevLen) {
            prevLen = states.count
            let unvisitedStates = states.keys.filter{!visited.contains($0)}.sorted()
            
            for state in unvisitedStates {
                visited.insert(state)
                computeTransitions(from: state)
            }
        }
    }
    
    private mutating func computeTransitions(from state: Int) {
        for transitionSymbol in states[state]!.dotSymbols {
            let newStateKernelRules = states[state]!.getItemsByAdvancingDot(after: transitionSymbol)
            let newStateItemSet = computeClosure(using: newStateKernelRules)
            let newStateNum = states.first{$0.value == newStateItemSet}?.key ?? states.count
            
            states[newStateNum] = states[newStateNum] ?? newStateItemSet
            states[state]?.transitions[transitionSymbol] = newStateNum
        }
    }
    
    mutating func createParseTable() {
        let rows = states.keys
        let cols = G.terminals + ["$"] + G.nonTerminals
        
        // create empty table
        for i in rows {
            actionTable[i] = [:]
            gotoTable[i] = [:]
        }
        
        // make shift and GOTO entries in table
        for a in 0..<rows.count {
            for symbol in cols {
                if let transitionState = states[a]?.transitions[symbol] {
                    if G.terminals.contains(symbol) {
                        actionTable[a]![symbol] = .shift(transitionState)
                    } else {
                        gotoTable[a]![symbol] = transitionState
                    }
                }
            }
        }
        
        // start REDUCE procedure
        // find 'handle' items and calculate follow.
        for (stateno, state) in states {
            for reduceItem in state.reduceItems {
                let ruleId = allRulesList.firstIndex(where: {$0 == reduceItem.rule})
                let followResult = follow(nt: reduceItem.lhs)
                for col in followResult {
                    actionTable[stateno]![col] = ruleId == 0 ? Action.accept : Action.reduce(reduceItem.rule)
                }
            }
        }
    }
    
    // Set of terminals that can appear immediately
    // to the right of Non-Terminal
    private func follow(nt: String) -> [String] {
        var solset: [String] = []
        if nt == allRulesList[0].lhs {
            solset.append("$")
        }
        
        let diction = allRulesList.map(\.lhs).dedupe()
        for curNT in diction {
            let rhs = allRulesList.filter{$0.lhs == curNT}.compactMap{$0.rhs}
            
            for subrule in rhs {
                if (!subrule.contains(nt)) {
                    continue
                }
                
                var tempSubrule = subrule
                while tempSubrule.contains(nt) {
                    let index_nt = tempSubrule.firstIndex(of: nt)!.advanced(by: 1)
                    tempSubrule = Array(tempSubrule[index_nt...])
                    
                    var res: [String] = []
                    if tempSubrule.count > 0 {
                        res = first(rhs: tempSubrule)
                        if res.contains(EPSILON) {
                            res.remove(EPSILON)
                            let ansNew = follow(nt: curNT)
                            res.append(contentsOf: ansNew)
                        }
                    } else {
                        if nt != curNT {
                            res = follow(nt: curNT)
                        }
                    }
                    solset.append(contentsOf: res)
                    solset = solset.dedupe()
                }
                
            }
        }
        
        return solset
    }
    
    
    // Set of terminals that can appear immediately
    // after a given non-terminal in a grammar.
    private func first(rhs: [String]) -> [String] {
        if rhs.isEmpty {
            return []
        }
        
        // recursion base condition for terminal or epsilon
        if G.terminals.contains(rhs[0]) {
            return [rhs[0]]
        } else if rhs[0] == EPSILON {
            return [EPSILON]
        }
        
        // condition for Non-Terminals
        
        var fres: [String] = []
        let rhs_rules = allRulesList.filter{$0.lhs == rhs[0]}.compactMap{$0.rhs}
        for itr in rhs_rules {
            fres.append(contentsOf: first(rhs: itr))
        }
        
        if (!fres.contains(EPSILON)) {
            return fres
        }
        
        // apply epsilon rule => f(ABC)=f(A)-{e} U f(BC)
        fres.remove(EPSILON)
        if (rhs.count > 1) {
            let ansNew = first(rhs: Array(rhs[1...]))
            return fres + ansNew
        }
        
        fres.append(EPSILON)
        return fres
    }
}
