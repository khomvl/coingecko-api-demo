import CoinGeckoAPI

struct AllTimeHighVisitor: PropertyVisitor {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func visit(_ data: CoinDetails) -> CoinDetailViewModel {
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        
        return .init(
            title: "All-Time High",
            value: formatter.string(from: data.allTimeHigh(in: currency))
        )
    }
}
