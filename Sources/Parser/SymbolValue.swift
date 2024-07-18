/// Symbols in the grammar become a kind of object. Values can be attached to each
/// symbol and operations carried out on those values when different grammar rules are recognized.
///
/// For terminals, the value is the string that was assigned to Token.value attribute in the lexer module.
/// The rule production should know how to convert string to G.Output
public enum SymbolValue<G: Parser> {
    case term(String)
    case nonTerm(String, G.Output)
    case eof

    public var termValue: String! {
        switch self {
        case .term(let c): c
        default: nil
        }
    }
    
    public var nonTermValue: G.Output! {
        switch self {
        case .nonTerm(_, let output): output
        default: nil
        }
    }
    
    public var name: String {
        switch self {
        case .term(let c): c
        case .nonTerm(let lhs, let ouput): "\(lhs)(\(ouput))"
        case .eof: ""
        }
    }
}
