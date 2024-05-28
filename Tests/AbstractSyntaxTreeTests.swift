import XCTest
import SwiftSly

final class AbstractSyntaxTreeTests: XCTestCase {
    func testCodingParser() throws {
        let charStream = "x + y * 2 + (4 + 5) / 3"
        let lexer = CodingLanguageLexer()
        let tokens = try lexer.tokenize(charStream)
        print(tokens)
        
        let parser = Parser<CodingLanguageRules>.SLR1()
        print(parser)
        
        let ast = try parser.parse(tokens: tokens)
        ast.print()
    }
    
    func testDragonBookExample() throws {
        let charStream = "x + y * z + (a + b) * c"
        let lexer = DragonBookLexer()
        let tokens = try lexer.tokenize(charStream)
        let parser = Parser<DragonBookGrammar>.SLR1()
        let ast = try parser.parse(tokens: tokens)
        ast.print()
    }
}
