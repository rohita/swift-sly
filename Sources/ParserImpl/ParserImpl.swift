/// The Parser is used to recognize language syntax that has been specified in the form of a context free grammar.
///
/// When parsing an expression, an underlying stack and the current input token determine what happens
/// next. If the next token looks like part of a valid grammar rule (based on other items on the stack), it is
/// generally shifted onto the stack. If the top of the stack contains a valid right-hand-side of a grammar rule,
/// it is usually “reduced” and the symbols replaced with the symbol on the left-hand-side. When this reduction occurs,
/// the appropriate action is triggered (if defined).
struct ParserImpl<G : Parser> {
    /// The parser's stack consists of:
    /// - Value:  For terminals, the value is whatever was assigned to Token.value attribute in the lexer module.
    ///           For non-terminals, the value is whatever was returned by the production defined for its rule.
    /// - State: Correspond to a finite-state machine that represents the parsing process.
    typealias StackItem = (value: SymbolValue<G>, state: Int)
    
    /// The parsing table has the action table and goto table
    /// - Action table: The action table is indexed by top-of-stack state and the current token, and
    ///             it tells which of the four actions to perform: **shift, reduce, accept, or reject**.
    /// - Goto table: The goto table is used during a reduce action. Gotos happen for each recognized rule.
    var parsingTable: ItemSetTable<G>
    
    init(parsingTable: ItemSetTable<G>) {
        self.parsingTable = parsingTable
    }
    
    func parse(tokens: [Token<G.TokenTypes>], debug: Bool=false) throws -> G.Output {
        var iterator = tokens.makeIterator()
        var current = iterator.next()
        var stateStack = Stack<StackItem>()
        let endSymbol = StackItem(value: .eof, state: 0)
        stateStack.push(endSymbol)
        var step = 1
        
    loop:
        while true {
            var debugString = print(stateStack)
            
            guard let stateBefore = stateStack.peek() else {
                throw ParserError.undefinedState
            }
            
            // This right here is when Lexer tokens map to Parser terminals.
            // current.name is terminal symbol and current.value is the symbol value
            // The current.name has to be part of Gammar rules.
            guard let action = parsingTable.actionTable[stateBefore.state]?[current?.type ?? "$"] else {
                throw ParserError.noAction(token: current?.type, state: stateBefore.state)
            }
            
            debugString.append("    Action: ")
            
            switch action {
                
                // A shift action means to push the current token onto the stack.
                // In fact, we actually push a state symbol onto the stack. Each
                // "shift" action in the action table includes the state to be pushed.
            case .shift(let state):
                let nextStackItem = StackItem(value: .term(current!.value), state: state)
                stateStack.push(nextStackItem)
                debugString.append("Shift \(current!.value)")
                current = iterator.next()
                
                // When we reduce using the grammar rule A → alpha, we pop alpha off
                // of the stack. If alpha contains N symbols, we pop N
                // states off of the stack. We then use the goto table to know what to push:
                // the goto table is indexed by state symbol t and nonterminal A, where t
                // is the state symbol that is on top of the stack after popping N times.
            case .reduce(let reduce):
                let rule = reduce
                debugString.append("Reduce \(rule)")
                var input: [SymbolValue<G>] = []
                for _ in rule.rhs {
                    input.insert(stateStack.pop()!.value, at: 0)
                }
                
                let output = rule.production(input)
                
                guard let stateAfter = stateStack.peek() else {
                    throw ParserError.undefinedState
                }
                
                guard let nextState = parsingTable.gotoTable[stateAfter.state]?[rule.lhs] else {
                    throw ParserError.noGoto(nonTerm: rule.lhs, state: stateAfter.state)
                }
                
                let nextStackItem = StackItem(value: .nonTerm(rule.lhs, output), state: nextState)
                stateStack.push(nextStackItem)
                
            case .accept:
                debugString.append("Accept")
                if debug {
                    Swift.print("\(step): \(debugString)")
                }
                break loop
            }
            
            if debug {
                Swift.print("\(step): \(debugString)")
            }
            step += 1
        }
        
        guard let next = stateStack.pop(), case .nonTerm(_, let finalOutput) = next.value else {
            throw ParserError.outputIsNil
        }
        
        return finalOutput
    }
    
    func print(_ stateStack: Stack<StackItem>) -> String {
        var sb = "Stack: "
        for symbol in stateStack.array {
            sb.append(symbol.value.name + " ")
        }
        sb.append("\n")
        return sb
    }

}


