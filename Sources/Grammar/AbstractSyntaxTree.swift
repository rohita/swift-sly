public protocol AbstractSyntaxTree: CustomDebugStringConvertible {
    var symbolName: String { get }
    var isLeaf: Bool { get }
}

public struct TerminalNode: AbstractSyntaxTree {
    public let symbolName: String
    public var isLeaf = true
    public let value: String
    
    public var debugDescription: String {
        return "\(value)"
    }
}

public struct NonTerminalNode: AbstractSyntaxTree {
    public let symbolName: String
    public var isLeaf = false
    public let children: [AbstractSyntaxTree]
    
    public var debugDescription: String {
        return "\(symbolName)"
    }
}

/// Default Output is AST
public extension Grammar {
    typealias Output = NonTerminalNode
}

extension AbstractSyntaxTree {
    public func printAST() {
        var sb = "";
        buildPrintString(stringBuilder: &sb, padding: "", pointer: "", node: self, hasRightSibling: false);
        Swift.print(sb)
    }
    
    func buildPrintString(
        stringBuilder: inout String,
        padding: String,
        pointer: String,
        node: AbstractSyntaxTree,
        hasRightSibling: Bool) {
            
            if node.isLeaf {
                stringBuilder.append("\(padding)\(pointer)\(node)\n")
                return
            }
            
            let nonTerm = node as! NonTerminalNode
            
            stringBuilder.append("\(padding)\(pointer)\(node)\n")
            let newPadding = hasRightSibling ? "\(padding)┃ " : "\(padding)  "
            for c in nonTerm.children.dropLast() {
                buildPrintString(stringBuilder: &stringBuilder, padding: newPadding, pointer: "┣╸", node: c, hasRightSibling: true)
            }
            buildPrintString(stringBuilder: &stringBuilder, padding: newPadding, pointer: "┗╸", node: nonTerm.children.last!, hasRightSibling: false)
    }
}
