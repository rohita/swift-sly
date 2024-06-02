import XCTest
@testable import SwiftSly

final class ItemSetTableTests: XCTestCase {
    
    func testPrintGrammar() throws {
        for rule in DragonBookGrammar.rules {
            print("\(rule)")
        }
        
        var p = ItemSetTable<DragonBookGrammar>()
        
        print("\nGrammar after Augmentation: \n")
        for rule in p.allRulesList {
            print("\(rule)")
        }
        
        print("\nCalculated closure: I0\n")
        let I0 = p.computeClosure(using: [Item(rule: p.allRulesList[0])])
        print(I0)
        
        p.generateStates(startingState: I0)
        print("\nStates Generated: \n")
        for st in p.states.sorted(by: { $0.key < $1.key }) {
            print("State = I\(st.key)")
            print(st.value)
        }
        
        print("Result of GOTO computation:\n")
        for st in p.states.sorted(by: { $0.key < $1.key }) {
            for transition in st.value.transitions {
                print("GOTO (I\(st.key) , \(transition.key)) = I\(transition.value)")
            }
            print("------")
        }
        
        p.createParseTable()
        let parser = Parser(actions: p.actionTable, gotos: p.gotoTable)
        
        print("\nSLR(1) parsing table:\n")
        print(parser)
        XCTAssertEqual(parser.actionTable, expectedActionTable(r: p.allRulesList))
        XCTAssertEqual(parser.gotoTable, expectedGotoTable())
    }
    
    func expectedActionTable(r: [Rule<DragonBookGrammar>]) -> [Int: [String: Action<DragonBookGrammar>]] {
        var table : [Int: [String: Action<DragonBookGrammar>]] = [:]
        for i in 0..<12 {
            table[i] = [:]
        }
        
        table[0] = ["(": .shift(4), "id": .shift(5)]
        table[1] = ["$": .accept, "+": .shift(6)]
        table[2] = ["*": .shift(7), "+": .reduce(r[2]), "$": .reduce(r[2]), ")": .reduce(r[2])]
        table[3] = ["*": .reduce(r[4]), "+": .reduce(r[4]), ")": .reduce(r[4]), "$": .reduce(r[4])]
        table[4] = ["id": .shift(5), "(": .shift(4)]
        table[5] = ["$": .reduce(r[6]), "+": .reduce(r[6]), "*": .reduce(r[6]), ")": .reduce(r[6])]
        table[6] = ["(": .shift(4), "id": .shift(5)]
        table[7] = ["id": .shift(5), "(": .shift(4)]
        table[8] = ["+": .shift(6), ")": .shift(11)]
        table[9] = [")": .reduce(r[1]), "$": .reduce(r[1]), "*": .shift(7), "+": .reduce(r[1])]
        table[10] = ["$": .reduce(r[3]), "*": .reduce(r[3]), "+": .reduce(r[3]), ")": .reduce(r[3])]
        table[11] = ["$": .reduce(r[5]), "+": .reduce(r[5]), ")": .reduce(r[5]), "*": .reduce(r[5])]
        
        return table
    }
    
    func expectedGotoTable() -> [Int: [String: Int]] {
        var table: [Int: [String: Int]] = [:]
        for i in 0..<12 {
            table[i] = [:]
        }
        
        table[0] = ["T": 2, "F": 3, "E": 1]
        table[4] = ["E": 8, "T": 2, "F": 3]
        table[6] = ["T": 9, "F": 3]
        table[7] = ["F": 10]
    
        return table
    }
}
