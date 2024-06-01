# SwiftSly
SwiftSly is used for parsing a context free grammer in Swift. 

SwiftSly is inspired from and is a 100% Swift implementation of 
the [Python's SLY project](https://sly.readthedocs.io/en/latest/index.html). 
Parsing is currently based on the SLR(1) algorithm. I am working on LALR(1) which is coming soon. 

## Documentation
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
```

Here's how we can use the above to parse an arithmetic expression: 

```swift
let lexer = CalcLexer()
let tokens = try lexer.tokenize("4 + 3 * 2 + (5 - 1) / 2")
let parser = CalcParser.SLR1()
let result = try parser.parse(tokens: tokens)
print(result)

// prints "12"
```

## More Examples
There are many more examples in the `Tests` folders: 
* [Parsing Character Set](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/CharacterSet.swift)
* [Simple Coding Language](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/CodingLanguage.swift)
* [Example from the "Dragon Book"](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/DragonBookExample.swift)
* [1+1 example from Wikipedia](https://github.com/rohita/swift-sly/blob/main/Tests/Examples/WikipediaExample.swift)

## References
It took many months of reading about lexers, parsers, compilers and tinkering with code, before I could get this libary working. 
Below are all the resources I referred to in building this library in those months. 

#### Inspiration
* https://sly.readthedocs.io/en/latest/sly.html
  
#### Books 
* [The "Dragon Book"](https://www.amazon.com/Compilers-Principles-Techniques-Tools-2nd/dp/0321486811): Compilers: Principles, Techniques, and Tools (Aho, Sethi, Ullman)
  
#### CS Courses
* http://www.cs.umsl.edu/~janikow/cs4280/bnf.pdf
* https://pages.cs.wisc.edu/~loris/cs536/readings/LR.html
* https://groups.seas.harvard.edu/courses/cs153/2018fa/lectures/Lec06-LR-Parsing.pdf
 
#### Videos
* Good Overview: https://www.youtube.com/watch?v=ox904ID0Mvs
* Part 1: https://www.youtube.com/watch?v=SyTXugfG9nw
* Part 2: https://www.youtube.com/watch?v=0rUJvQ3-GwI
 
#### Wiki
* https://en.wikipedia.org/wiki/LR_parser
* https://en.wikipedia.org/wiki/Simple_LR_parser

#### Blogs
* http://blog.matthewcheok.com/writing-a-lexer-in-swift/
* http://blog.matthewcheok.com/writing-a-parser-in-swift/
* http://blog.matthewcheok.com/writing-a-parser-in-swift-part-2/
* https://medium.com/@markus_25434/writing-clr-1-parsers-in-swift-6a20cf5cdf06
* https://www.geeksforgeeks.org/compiler-design-slr1-parser-using-python/

#### Github
* https://github.com/dabeaz/sly/
* https://github.com/AnarchoSystems/LRParser
* https://github.com/matthewcheok/Kaleidoscope/tree/master

