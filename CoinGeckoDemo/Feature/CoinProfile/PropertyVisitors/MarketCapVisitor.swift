import CoinGeckoAPI

struct MarketCapVisitor: PropertyVisitor {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func visit(_ data: CoinDetails) -> CoinDetailViewModel {
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        
        return .init(
            title: "Market Cap",
            value: formatter.string(from: data.marketCap(in: currency))
        )
    }
}
