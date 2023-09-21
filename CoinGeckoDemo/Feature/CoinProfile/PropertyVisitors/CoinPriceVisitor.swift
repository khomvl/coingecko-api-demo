import CoinGeckoAPI

struct CoinPriceVisitor: PropertyVisitor {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func visit(_ data: CoinDataModel) -> CoinDetailViewModel {
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        
        return .init(
            title: "\(data.name) Price",
            value: formatter.string(from: data.currentPrice)
        )
    }
}
