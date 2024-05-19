enum ParserError<G : Grammar>: Error {
    case undefinedState
    case noAction(token: String?, state: Int)
    case noGoto(nonTerm: String, state: Int)
}
