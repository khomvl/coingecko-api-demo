import Foundation
import CoinGeckoAPI

final class CoinListViewModel: ObservableObject {
    private let client: APIClient
    private var pageSize = 15
    private var currentPage = 1
    private let threshold = 3
    private var currentTask: Task<Void, Error>?
    private var didReachEnd = false
    
    var currency: Currency = .usd {
        didSet {
            reset()
        }
    }
    
    @Published var coins: [Coin] = []
    @Published var error: Error?
    
    init(client: APIClient = DIContainer.shared.resolve(type: APIClient.self)) {
        self.client = client
    }
    
    func fetchMoreCoins() {
        if didReachEnd {
            return
        }
        
        currentTask?.cancel()
        currentTask = Task { @MainActor in
            if Task.isCancelled {
                return
            }
            
            do {
                let endpoint = CoinList.Endpoint(page: currentPage, perPage: pageSize, vsCurrency: currency)
                let newCoins = try await client.request(endpoint: endpoint)
                
                if Task.isCancelled {
                    return
                }

                if newCoins.isEmpty {
                    didReachEnd = true
                    return
                }

                coins += newCoins
                currentPage += 1
                pageSize = 10
            } catch {
                if Task.isCancelled {
                    return
                }
                
                self.error = error
            }
        }
    }
    
    func shouldFetchMore(id: String) -> Bool {
        coins.firstIndex { $0.id == id } ?? -1 == coins.count - threshold
    }
    
    func reset() {
        currentPage = 1
        coins = []
        didReachEnd = false
        error = nil
        fetchMoreCoins()
    }
}
