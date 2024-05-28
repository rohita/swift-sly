import XCTest
import SwiftSly

final class ParserTests: XCTestCase {
    func testTG2() throws {
        let lexer = TG2Lexer()
        let parser = Parser<TG2Rules>.SLR1()
        let tokens = try lexer.tokenize("1 + 1 * 1 + 0")
        XCTAssertEqual(2, try parser.parse(tokens: tokens))
    }
    
    let lexer1 = CharacterSetLexer()
    let parser1 = Parser<CharacterSetRules>.SLR1()
    
    func testGrammerLexerRange() throws {
        let expected: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K",
                                     "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V",
                                     "W", "X", "Y", "Z"]
        let parsed = try parser1.parse(tokens: lexer1.tokenize("A-Z"))
        XCTAssertEqual(expected, parsed)
    }
    
    func testGrammerLexerChar() throws {
        let parsed = try parser1.parse(tokens: lexer1.tokenize("AZ"))
        XCTAssertEqual(["A", "Z"], parsed)
    }
    
    func testSingleChar() throws {
        let parsed = try parser1.parse(tokens: lexer1.tokenize("a"))
        XCTAssertEqual(["a"], parsed)
    }
    
    func testGrammerLexerDigit() throws {
        let expected: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let parsed = try parser1.parse(tokens: lexer1.tokenize("[:digit:]"))
        XCTAssertEqual(expected, parsed)
    }
    
    func testGrammerLexerDigitPlusRange() throws {
        let expected: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d"]
        let parsed = try parser1.parse(tokens: lexer1.tokenize("[:digit:]a-d"))
        XCTAssertEqual(expected, parsed)
    }
    
    func testGrammerLexerTwoClasses() throws {
        let expected: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " ", "\t"]
        let tokens = try lexer1.tokenize("[:digit:][:blank:]")
        let parsed = try parser1.parse(tokens: tokens)
        XCTAssertEqual(expected, parsed)
    }
}


