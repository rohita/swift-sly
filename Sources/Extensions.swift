import Foundation

extension String {
    func split(_ seperator: String = " ") -> [String] {
        self.split(separator: seperator).compactMap{String($0)}
    }
    
    func strip() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
