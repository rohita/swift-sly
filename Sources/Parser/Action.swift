// Defines the action to be taken in a parsing table
enum Action<G: Grammar> : Equatable {
    case shift(Int)
    case reduce(Rule<G>)
    case accept
}
