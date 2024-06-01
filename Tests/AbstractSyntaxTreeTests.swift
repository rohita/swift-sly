import XCTest
import SwiftSly

final class AbstractSyntaxTreeTests: XCTestCase {
    func testCodingParserDef() throws {
        let charStream = "def sum(x, y){ x+y }"
        let lexer = CodingLanguageLexer()
        let tokens = try lexer.tokenize(charStream)
        let parser = Parser<CodingLanguageRules>.SLR1()
        let ast = try parser.parse(tokens: tokens)
        print(ast)
    }
    
    func testCodingParserCall() throws {
        let charStream = "sum(4, 3)"
        let lexer = CodingLanguageLexer()
        let tokens = try lexer.tokenize(charStream)
        let parser = Parser<CodingLanguageRules>.SLR1()
        let ast = try parser.parse(tokens: tokens)
        print(ast)
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
