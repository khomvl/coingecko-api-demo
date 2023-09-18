import Foundation
import Combine
import CoinGeckoAPI

final class CoinDetailListViewModel: ObservableObject {
    private let coinId: String
    private let currency: Currency
    private let client: APIClient
    @Published var details: [CoinDetailViewModel] = []
    
    init(
        coinId: String,
        currency: Currency,
        client: APIClient = DIContainer.shared.resolve(type: APIClient.self)
    ) {
        self.coinId = coinId
        self.currency = currency
        self.client = client
    }
    
    func fetchCoinDetails() {
        Task { @MainActor in
            let endpoint = Details.Endpoint(id: self.coinId)
            let details = try await client.request(endpoint: endpoint)
            
            self.details = [
                // TODO: erase type to iterate over
                CoinPriceVisitor(currency: currency).visit(details),
                Coin24HLowHighVisitor(currency: currency).visit(details),
                MarketCapRankVisitor().visit(details),
                MarketCapVisitor(currency: currency).visit(details),
                TotalVolumeVisitor(currency: currency).visit(details),
                AllTimeHighVisitor(currency: currency).visit(details),
                AllTimeLowVisitor(currency: currency).visit(details)
            ]
        }
    }
}
