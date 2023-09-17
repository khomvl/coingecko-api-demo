public enum Currency: String {
    case usd
    
    public var symbol: String {
        switch self {
        case .usd:
            return "$"
        }
    }
}
