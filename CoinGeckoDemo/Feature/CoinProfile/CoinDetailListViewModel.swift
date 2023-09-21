import Foundation
import SwiftUI
import Combine
import CoinGeckoAPI

final class CoinDetailListViewModel: ObservableObject {
    var details: [CoinDetailViewModel] = []
    
    init(coinData: CoinDataModel, currency: Currency) {
        details = [
            // TODO: erase type to iterate over
            CoinPriceVisitor(currency: currency).visit(coinData),
            Coin24HLowHighVisitor(currency: currency).visit(coinData),
            MarketCapRankVisitor().visit(coinData),
            MarketCapVisitor(currency: currency).visit(coinData),
            TotalVolumeVisitor(currency: currency).visit(coinData),
            AllTimeHighVisitor(currency: currency).visit(coinData),
            AllTimeLowVisitor(currency: currency).visit(coinData)
        ]
    }
}
