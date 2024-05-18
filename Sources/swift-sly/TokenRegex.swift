/**
 The first parameter in the tuple represents the regular expression we want
 to match at the beginning of the context and the second parameter is a
 closure that will generate the relevant token.
 
 Example 1: This defines a token rule. 
 ```
 TokenRule(.Number, pattern: "[0-9.]+")
 ```
 
 */
public struct TokenRegex<T: Tokenizable> {
    public let type: T
    public let pattern: String
    public let overrideAction: (Token<T>) -> Token<T>
    
    public init(_ type: T, pattern: String, overrideAction: @escaping (Token<T>) -> Token<T> = {$0}) {
        self.type = type
        self.pattern = pattern
        self.overrideAction = overrideAction
    }
}
