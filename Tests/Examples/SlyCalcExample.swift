/// Example from: https://sly.readthedocs.io/en/latest/index.html
///
/// ```
/// expr   : expr + term
///        | expr - term
///        | term
///
/// term   : term * factor
///        | term / factor
///        | factor
///
/// factor : NUMBER
///        | ( expr )
/// ```


import SwiftSly

final class CalcLexer: Lexer {
    enum TokenTypes: String, Tokenizable {
        case NUMBER
    }
    
    static var ignore = "[ \t\n]"
    static var literals = ["+", "-", "*", "/", "(", ")" ]
    static var tokenRules = [
        TokenRegex(TokenTypes.NUMBER, pattern: "\\d+"),
    ]
}

final class CalcParser: Grammar {
    typealias Output = Int
    typealias TokenTypes = CalcLexer.TokenTypes
    static var rules: [Rule<CalcParser>] = [
        Rule("expr -> expr + term") { p in
            p[0].nonTermValue! + p[2].nonTermValue!
        },
        Rule("expr -> expr - term") { p in
            p[0].nonTermValue! - p[2].nonTermValue!
        },
        Rule("expr -> term") { p in
            p[0].nonTermValue!
        },
        Rule("term -> term * factor") { p in
            p[0].nonTermValue! * p[2].nonTermValue!
        },
        Rule("term -> term / factor") { p in
            p[0].nonTermValue! / p[2].nonTermValue!
        },
        Rule("term -> factor") { p in
            p[0].nonTermValue!
        },
        Rule("factor -> NUMBER") { p in
            Int(p[0].termValue!)!
        },
        Rule("factor -> ( expr )") { p in
            p[1].nonTermValue!
        },
    ]
}


