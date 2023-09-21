import Foundation
import CoinGeckoAPI

struct CoinDataModel: Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: URL
    var currentPrice: Decimal?
    var priceChangePercentage24H: Decimal?
    var marketCapRank: Int?
    var allTimeHigh: Decimal?
    var allTimeLow: Decimal?
    var marketCap: Decimal?
    var totalVolume: Decimal?
    var high24H: Decimal?
    var low24H: Decimal?
    var chartData: [CandleData] = []
    
    init(id: String, symbol: String, name: String, image: URL) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
    }
    
    init(coin: Coin) {
        self.id = coin.id
        self.symbol = coin.symbol
        self.name = coin.name
        self.image = coin.image
        self.currentPrice = coin.currentPrice
        self.priceChangePercentage24H = coin.priceChangePercentage24H
    }
    
    mutating func enrich(with coinDetails: CoinDetails, currency: Currency) {
        self.currentPrice = coinDetails.currentPrice(in: currency)
        self.priceChangePercentage24H = coinDetails.priceChangePercentage24H(in: currency)
        self.marketCapRank = coinDetails.marketCapRank
        self.allTimeLow = coinDetails.allTimeLow(in: currency)
        self.allTimeHigh = coinDetails.allTimeHigh(in: currency)
        self.marketCap = coinDetails.marketCap(in: currency)
        self.totalVolume = coinDetails.totalVolume(in: currency)
        self.high24H = coinDetails.high24H(in: currency)
        self.low24H = coinDetails.low24H(in: currency)
    }
    
    mutating func enrich(with chartData: [CandleData]) {
        if chartData.isEmpty {
            return
        }
        
        self.chartData = chartData
    }
}
