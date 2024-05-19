struct Stack<T> {
    private var array: [T] = []

    var isEmpty: Bool {
        array.isEmpty
    }
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        isEmpty ? nil : array.removeLast()
    }
    
    func peek() -> T? {
        array.last
    }
}
