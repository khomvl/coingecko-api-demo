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
        let formatter = Formatters.priceFormatter
        formatter.currencyCode = currency.rawValue
        self.price = formatter.string(from: NSNumber(value: coin.currentPrice)) ?? "—"
        
        let changePositive = coin.priceChangePercentage24H > 0
        self.priceChange = String(format: "\(changePositive ? "+" : "")%.2f%%", coin.priceChangePercentage24H)
        self.priceColor = changePositive ? .textPriceUp : .textPriceDown
    }
}
