// Defines the action to be taken in a parsing table
enum Action<G: Parser> : Equatable {
    case shift(Int)
    case reduce(Rule<G>)
    case accept
}
