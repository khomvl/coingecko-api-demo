import Foundation
import Combine
import CoinGeckoAPI

final class ChartViewModel: ObservableObject {
    private let coinId: String
    private let client: APIClient
    @Published var candles: [CandleData] = []
    @Published var timeoutExceeded: Bool = false
    
    private var fetchTask: Task<Void, Error>?
    private var timeoutTask: Task<Void, Error>?
    
    init(
        coinId: String,
        client: APIClient = DIContainer.shared.resolve(type: APIClient.self)
    ) {
        self.coinId = coinId
        self.client = client
        
        fetchCandlesData()
    }
    
    func fetchCandlesData() {
        timeoutExceeded = false
        fetchTask?.cancel()
        timeoutTask?.cancel()
        timeoutTask = Task.delayed(byTimeInterval: 10) { @MainActor in
            self.timeoutExceeded = true
        }
        
        fetchTask = Task { @MainActor in
            if Task.isCancelled {
                return
            }
            
            let endpoint = Chart.Endpoint(coinId: coinId)
            candles = try await client.request(endpoint: endpoint)
            timeoutExceeded = false
            timeoutTask?.cancel()
        }
    }
}

extension CandleData: Identifiable {
    public var id: String {
        "\(timestamp.timeIntervalSince1970)"
    }
}
