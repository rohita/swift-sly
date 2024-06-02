/// The Gramar specifies the syntax of the language to be parsed.
///
/// The syntax is defined by a list of grammar rules. A rule is defined by a string of the form 
/// ```
/// LHS -> RHS
/// ```
///
/// For example:
/// ```
/// E -> E * B
/// E -> E + B
/// E -> B
/// B -> 0
/// B -> 1
/// ```
/// In grammar, there are two types of symbols:
/// - term Terminals: Raw input tokens such as `0, 1, +, -`.
/// - term Non-terminals: LHS symbols such as `E` and `B`.
///
/// The very first grammar rule defines the top of the parser and its LHS represents the starting symbol.
///
/// The rule also define a production method which return a value that becomes associated with its LHS symbol elsewhere.
/// This is how values propagate within the grammar. The method is triggered when that grammar rule is recognized on the input.
/// As an argument, the method receives an array of symbol values "p", corresponding to the RHS of the rule. You can
/// access the symbol values by the index of its position in the RHS, e.g.
/// ```swift
/// Rule("E -> E + B") { p in
///    return p[0] + p[2]
/// }
/// ```
public protocol Grammar {
    /// The final output type that the Grammar produces
    associatedtype Output
    
    /// Lexer token types
    associatedtype TokenTypes: Tokenizable

    /// List of grammar rules
    static var rules: [Rule<Self>] { get }
}
