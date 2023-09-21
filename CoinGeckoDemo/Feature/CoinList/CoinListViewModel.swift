import Foundation
import CoinGeckoAPI

final class CoinListViewModel: ObservableObject {
    private let client: APIClient
    private var pageSize = 10
    private var currentPage = 1
    private var didReachEnd = false
    private let threshold = 3
    private var currentTask: Task<Void, Error>?
    private var retryTask: Task<Void, Error>?
    private let retryRate: TimeInterval = 60
    
    var currency: Currency = .usd {
        didSet {
            reset()
        }
    }
    
    @Published var coins: [Coin] = []
    @Published var errorMessage: String?
    
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
            } catch {
                if Task.isCancelled {
                    return
                }
                
                self.errorMessage = (error as? APIError)?.status.errorMessage
                
                startRetrying()
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
        errorMessage = nil
        stopRetrying()
        fetchMoreCoins()
    }
}

private extension CoinListViewModel {
    func startRetrying() {
        guard self.retryTask == nil else {
            return
        }
        
        retryTask = Task.delayed(byTimeInterval: retryRate) { [self] in
            fetchMoreCoins()
            retryTask = nil
        }
    }
    
    func stopRetrying() {
        retryTask?.cancel()
        retryTask = nil
    }
}
