import SwiftSly
import Foundation

/// Example from:
/// http://blog.matthewcheok.com/writing-a-lexer-in-swift/
/// http://blog.matthewcheok.com/writing-a-parser-in-swift/
/// http://blog.matthewcheok.com/writing-a-parser-in-swift-part-2/
///
/// This lexer and grammer will recognize the following code snippet
/// ```
/// def foo(x, y)
///     x + y * 2 + (4 + 5) / 3
///
/// foo(3, 4)
/// ```
final class CodingLanguageLexer: Lexer {
    public enum TokenTypes: String, Tokenizable {
        case DEF, ID, NUM, OP
    }
    
    static var literals = ["(", ")", ",", "{", "}"]
    static var ignore = "[ \t\n]"
    
    static var tokenRules: [TokenRegex<TokenTypes>] = [
        TokenRegex(.DEF,  pattern: "[a-zA-Z][a-zA-Z0-9]*") { token in
            token.value == "def" ? token : Token(TokenTypes.ID, value: token.value)
        },
        TokenRegex(.NUM, pattern: "[0-9.]+"),
        TokenRegex(.OP, pattern: "(\\+|\\-|\\*|\\/)"),
    ]
}

final class CodingLanguageRules: Parser {
    typealias Output = ExprNode
    typealias TokenTypes = CodingLanguageLexer.TokenTypes
    
    static var rules: [Rule<CodingLanguageRules>] = [
        Rule("Function -> Prototype { Expression }") { p in
            FunctionNode(prototype: p[0].nonTermValue as? PrototypeNode, body: p[2].nonTermValue)
        },
        Rule("Function -> Call") { p in
            FunctionNode(prototype: nil, body: p[0].nonTermValue)
        },
        Rule("Prototype -> DEF ID ( Arguments )") { p in
            var args: PrototypeNode! = p[3].nonTermValue as? PrototypeNode
            return PrototypeNode(name: p[1].termValue, argumentNames: args.argumentNames)
        },
        Rule("Arguments -> Arguments , ID") { p in
            var args: PrototypeNode! = p[0].nonTermValue as? PrototypeNode
            return PrototypeNode(name: "", argumentNames: args.argumentNames + [p[2].termValue])
        },
        Rule("Arguments -> ID") { p in
            PrototypeNode(name: "", argumentNames: [p[0].termValue])
        },
        Rule("Expression -> PrimaryExpression OP Expression") { p in
            BinaryOpNode(op: p[1].termValue, lhs: p[0].nonTermValue, rhs: p[2].nonTermValue)
        },
        Rule("Expression -> PrimaryExpression") { p in
            p[0].nonTermValue
        },
        Rule("PrimaryExpression -> Call") { p in
            p[0].nonTermValue
        },
        Rule("Call -> ID ( Parameters )") { p in
            var args: CallNode! = p[2].nonTermValue as? CallNode
            return CallNode(name: p[0].termValue, arguments: args.arguments)
        },
        Rule("Parameters -> Parameters , Expression") { p in
            var args: CallNode! = p[0].nonTermValue as? CallNode
            return CallNode(name: "", arguments: args.arguments + [p[2].nonTermValue])
        },
        Rule("Parameters -> Expression") { p in
            CallNode(name: "", arguments: [p[0].nonTermValue])
        },
        Rule("PrimaryExpression -> ID") { p in
            VariableNode(name: p[0].termValue)
        },
        Rule("PrimaryExpression -> NUM") { p in
            NumberNode(value: (p[0].termValue as NSString).floatValue)
        },
        Rule("PrimaryExpression -> ( Expression )") { p in
            p[1].nonTermValue
        },
    ]
    
    struct NumberNode: ExprNode {
        let value: Float
        var description: String {
            return "NumberNode(\(value))"
        }
    }
    
    struct VariableNode: ExprNode {
        let name: String
        var description: String {
            return "VariableNode(\(name))"
        }
    }
    
    struct BinaryOpNode: ExprNode {
        let op: String
        let lhs: ExprNode
        let rhs: ExprNode
        var description: String {
            return "BinaryOpNode(\(op), lhs: \(lhs), rhs: \(rhs))"
        }
    }
    
    struct PrototypeNode: ExprNode {
        let name: String
        let argumentNames: [String]
        var description: String {
            return "PrototypeNode(name: \(name), argumentNames: \(argumentNames))"
        }
    }

    struct FunctionNode: ExprNode {
        let prototype: PrototypeNode?
        let body: ExprNode
        var description: String {
            return "FunctionNode(prototype: \(prototype), body: \(body))"
        }
    }
    
    struct CallNode: ExprNode {
        let name: String
        let arguments: [ExprNode]
        var description: String {
            return "CallNode(name: \(name), arguments: \(arguments))"
        }
    }
    
}

protocol ExprNode: CustomStringConvertible {
}
