protocol PropertyVisitor {
    associatedtype SourceType
    associatedtype ResultType
    
    func visit(_ data: SourceType) -> ResultType
}
