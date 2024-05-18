/**
 This represents the regular expression we want to match at the beginning
 of the text that will generate the relavant token.
 
 Example 1: This defines a token regular expression to identify `NUM` token.
 ```swift
 TokenRegex(.NUM, pattern: "[0-9.]+")
 ```
 
 When certain tokens are matched, you may want to trigger some kind of action
 that performs extra processing. The `overrideAction` parameter is a
 closure that will generate the relevant token. E.g.
 ```swift
 TokenRegex(.DEF,  pattern: "[a-zA-Z][a-zA-Z0-9]*") { token in
     token.value == "def" ? token : Token(TokenTypes.ID, value: token.value)
 }
 ```

 The method always takes a single argument which is an instance of type Token. 
 The function can change the token type and value as it sees appropriate. When finished, the resulting
 token object should be returned as a result. If no value is returned by the function,
 the token is discarded and the next token read.
 */
public struct TokenRegex<T: Tokenizable> {
    public let type: T
    public let pattern: String
    public let overrideAction: (Token<T>) -> Token<T>?
    
    public init(_ type: T, pattern: String, overrideAction: @escaping (Token<T>) -> Token<T>? = {$0}) {
        self.type = type
        self.pattern = pattern
        self.overrideAction = overrideAction
    }
}
