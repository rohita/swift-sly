import XCTest

final class LexerTests: XCTestCase {
    func testCodingLexer() throws {
        let charStream = "def foo(x, y) x + y * 2"
        let lexer = CodingLanguageLexer()
        let result = try lexer.tokenize(charStream)
        print(result)
    }
}
