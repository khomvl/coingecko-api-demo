import SwiftUI
import CoinGeckoAPI

struct CoinListItemViewModel: Identifiable {
    var id: String
    var title: String
    var imageUrl: URL
    var subtitle: String
    var price: String
    var priceChange: String
    var priceColor: Color
    
    init(coin: Coin, currency: Currency) {
        self.id = coin.id
        self.title = coin.symbol.uppercased()
        self.imageUrl = coin.image
        self.subtitle = coin.name
        
        // FIXME: potential bug here, currency is lacking single source of truth
        let priceFormatter = Formatters.priceFormatter
        priceFormatter.currencyCode = currency.rawValue
        self.price = priceFormatter.string(from: coin.currentPrice)
        
        let percentFormatter = Formatters.percentFormatter
        let changePositive = coin.priceChangePercentage24H > 0
        let formattedPercentChange = percentFormatter.string(from: coin.priceChangePercentage24H / 100)
        self.priceChange = "\(changePositive ? "+" : "")\(formattedPercentChange)"
        self.priceColor = changePositive ? .textPriceUp : .textPriceDown
    }
}
