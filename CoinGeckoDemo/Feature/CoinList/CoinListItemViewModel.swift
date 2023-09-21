import SwiftUI
import CoinGeckoAPI

struct CoinListItemViewModel: Identifiable {
    let id: String
    let title: String
    let imageUrl: URL
    let subtitle: String
    let price: String
    let priceChange: String
    let priceColor: Color
    
    init(coinData: CoinDataModel, currency: Currency) {
        self.id = coinData.id
        self.title = coinData.symbol.uppercased()
        self.imageUrl = coinData.image
        self.subtitle = coinData.name
        
        // FIXME: potential bug here, currency is lacking single source of truth
        let priceFormatter = Formatters.priceFormatter
        priceFormatter.currencyCode = currency.rawValue
        self.price = priceFormatter.string(from: coinData.currentPrice)
        
        if let priceChange = coinData.priceChangePercentage24H {
            let percentFormatter = Formatters.percentFormatter
            let changePositive = priceChange > 0
            let formattedPercentChange = percentFormatter.string(from: priceChange / 100)
            self.priceChange = "\(changePositive ? "+" : "")\(formattedPercentChange)"
            self.priceColor = changePositive ? .textPriceUp : .textPriceDown
        } else {
            self.priceChange = "—"
            self.priceColor = .textSecondary
        }
    }
}
