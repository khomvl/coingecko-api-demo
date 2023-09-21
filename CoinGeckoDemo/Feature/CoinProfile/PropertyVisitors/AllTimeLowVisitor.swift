import CoinGeckoAPI

struct AllTimeLowVisitor: PropertyVisitor {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func visit(_ data: CoinDataModel) -> CoinDetailViewModel {
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        
        return .init(
            title: "All-Time Low",
            value: formatter.string(from: data.allTimeLow)
        )
    }
}
