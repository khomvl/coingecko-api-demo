import Combine
import CoinGeckoAPI

final class AppState: ObservableObject {
    var currentPage: Int = 1
    var didReachEnd = false
    var coinIdsList: [String] = []
    @Published var coinIdToData: [String: CoinDataModel] = [:]
    
    var coinData: [CoinDataModel] {
        coinIdsList.compactMap { coinIdToData[$0] }
    }
    
    var currency: Currency = .usd
}
