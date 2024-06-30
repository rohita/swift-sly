# SwiftSly
**SwiftSly** is library for writing parsers and compilers in Swift. This library is heavily inspired from the [Python's SLY project](https://sly.readthedocs.io/en/latest/index.html). 
Parsing is currently based on the SLR(1) algorithm. I am working on LALR(1) which is coming soon. 

## Documentation Wiki
For detailed documention please see the [wiki](https://github.com/rohita/swift-sly/wiki). But to get started quickly, 
see an example below. 

## An Example
Suppose you wanted to parse simple arithmetic expressions and you have the 
grammar specification like this:

```
expr   : expr + term
       | expr - term
       | term

term   : term * factor
       | term / factor
       | factor

factor : NUMBER
       | ( expr )
```

Here’s what it looks like to write a parser that can evaluate the above grammer:

```swift
import SwiftSly

// Define a class which conforms to the 'Lexer' protocol
final class CalcLexer: Lexer {                 

    // Define all of the possible token types that can be produced by the lexer
    enum TokenTypes: String, Tokenizable {      
        case NUMBER                          
    }

    // Define any ignored characters between tokens
    static var ignore = "[ \t\n]"              

    // Define any single character literals that are returned 'as is' when encountered by the lexer
    static var literals = ["+", "-", "*", "/", "(", ")" ] 

    // Define regular expression rules for each of the tokens
    static var tokenRules = [                  
        TokenRegex(TokenTypes.NUMBER, pattern: "\\d+"),
    ]
}

// Define a class which conforms to the 'Parser' protocol
final class CalcParser: Parser {

    // Define the output type that the Parser produces
    typealias Output = Int

    // Link to the Lexer token types
    typealias TokenTypes = CalcLexer.TokenTypes

    // Define rules and their productions
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
```

Here's how we can use the above to parse an arithmetic expression: 

```swift
let lexer = CalcLexer()
let tokens = try lexer.tokenize("4 + 3 * 2 + (5 - 1) / 2")
let parser = CalcParser()
let result = try parser.parse(tokens: tokens)
print(result)

// prints "12"
```

## More Examples
There are many more examples in the `Tests` folder: 
* [Parsing Character Set](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/CharacterSet.swift)
* [Simple Coding Language](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/CodingLanguage.swift)
* [Example from the "Dragon Book"](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/DragonBookExample.swift)
* [1+1 example from Wikipedia](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/WikipediaExample.swift)

## References
It took many months of reading about lexers, parsers, compilers and tinkering with code, before I could get this libary working. 
[Here are all the resources](https://github.com/rohita/swift-sly/wiki/References) I referred to in building this library in those months. 

