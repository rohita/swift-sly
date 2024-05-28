import XCTest
import SwiftSly

final class LexerTests: XCTestCase {
    func testCodingLexer() throws {
        let charStream = "def foo(x, y) x + y * 2"
        let lexer = CodingLanguageLexer()
        let tokens = try lexer.tokenize(charStream)
        
        let expected: [Token<CodingLanguageLexer.TokenTypes>] =
        [Token(.DEF, value: "def"), Token(.ID, value: "foo"),
         Token("("), Token(.ID, value: "x"), Token(","), Token(.ID, value: "y"), Token(")"),
         Token(.ID, value: "x"), Token(.OP, value: "+"), Token(.ID, value: "y"), 
         Token(.OP, value: "*"), Token(.NUM, value: "2")]
        
        XCTAssertEqual(expected, tokens)
    }
    
    func testTestGrammer2() throws {
        let expected: [Token<TG2Lexer.TokenTypes>] = [Token("1"), Token("+"), Token("1"), Token("*"), Token("0")]
        let charStream = "1 + 1 * 0"
        let lexer = TG2Lexer()
        let tokens = try lexer.tokenize(charStream)
        XCTAssertEqual(expected, tokens)
    }
    
    let lexer1 = CharacterSetLexer()
    
    func testLexerRange() throws {
        let expected: [Token<CharacterSetLexer.TokenTypes>] = [Token(.CHAR, value: "A"), Token("-"), Token(.CHAR, value: "Z")]
        let tokens = try lexer1.tokenize("A-Z")
        XCTAssertEqual(expected, tokens)
    }
    
    func testLexerChar() throws {
        let expected: [Token<CharacterSetLexer.TokenTypes>] = [Token(.CHAR, value: "A"), Token(.CHAR, value: "Z")]
        let tokens = try lexer1.tokenize("AZ")
        XCTAssertEqual(expected, tokens)
    }
    
    func testSingleChar() throws {
        let tokens = try lexer1.tokenize("a")
        XCTAssertEqual([Token(.CHAR, value: "a")], tokens)
    }
    
    func testLiterals() throws {
        let expected: [Token<CharacterSetLexer.TokenTypes>] = [
            Token("["),
            Token(":"),
            Token(.CLASSNAME, value: "digit"),
            Token(":"),
            Token("]")
        ]
        let tokens = try lexer1.tokenize("[:digit:]")
        XCTAssertEqual(expected, tokens)
    }
}
