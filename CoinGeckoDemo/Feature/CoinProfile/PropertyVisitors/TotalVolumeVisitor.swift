import CoinGeckoAPI

struct TotalVolumeVisitor: PropertyVisitor {
    private let currency: Currency
    
    init(currency: Currency) {
        self.currency = currency
    }
    
    func visit(_ data: CoinDetails) -> CoinDetailViewModel {
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        
        return .init(
            title: "Total Volume",
            value: formatter.string(from: data.totalVolume(in: currency))
        )
    }
}
