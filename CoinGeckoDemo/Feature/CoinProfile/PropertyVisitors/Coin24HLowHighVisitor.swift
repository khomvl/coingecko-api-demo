import CoinGeckoAPI

struct Coin24HLowHighVisitor: PropertyVisitor {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func visit(_ data: CoinDetails) -> CoinDetailViewModel {
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        
        let formattedLowPrice = formatter.string(from: data.low24H(in: currency))
        let formattedHighPrice = formatter.string(from: data.high24H(in: currency))
        
        return .init(
            title: "24h Low / 24h High",
            value: "\(formattedLowPrice) / \(formattedHighPrice)"
        )
    }
}
