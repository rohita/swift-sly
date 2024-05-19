import Foundation

extension String {
    func split(_ seperator: String = " ") -> [String] {
        self.split(separator: seperator).compactMap{String($0)}
    }
    
    func strip() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension RangeReplaceableCollection where Index: BinaryInteger, Element: Hashable {
    func dedupe() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
