/**
 Represents token symbols. This is what links the lexer to token to parser.
 The grammer defines these as terminals, in addititions to literals.
 
 These are generally defined as Enums. E.g.
 ```swift
 public enum TokenTypes: String, Tokenizable {
     case Define, Identifier, Number
 }
 ```
 In this example, the Grammer can use "Define", "Identifier" and "Number" as terminals when defining rules.
 The casing matters, since the `RawRepresentable` will use the string to match Grammer symbols.
 
 The raw values can be different, but they have to match symbols used in the Grammer.
 ```swift
 public enum TokenTypes: String, Tokenizable {
     case Define = "DEF"
     case Identifier = "ID"
     case Number = "NUM"
 }
 ```
 Here the Grammer can use "DEF", "ID" and "NUM" as terminals when defining rules.
 */
public protocol Tokenizable:
    RawRepresentable,
    Hashable
    where RawValue == String {}
