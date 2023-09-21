import CoinGeckoAPI

struct CoinListInteractor {
    private let pageSize = 10
    private let threshold = 3
    private let appState: AppState
    private let apiClient: APIClient
    
    init(
        appState: AppState = DIContainer.shared.resolve(type: AppState.self),
        apiClient: APIClient = DIContainer.shared.resolve(type: APIClient.self)
    ) {
        self.appState = appState
        self.apiClient = apiClient
    }
    
    @MainActor
    func fetchMoreCoins() async throws {
        if appState.didReachEnd {
            return
        }
        
        let endpoint = CoinList.Endpoint(
            page: appState.currentPage,
            perPage: pageSize,
            vsCurrency: appState.currency
        )
        let newCoins = try await apiClient.request(endpoint: endpoint)
        
        if Task.isCancelled {
            return
        }

        if newCoins.isEmpty {
            appState.didReachEnd = true
            return
        }
        
        appState.coinIdsList += newCoins.map { $0.id }
        
        let newData: [String: CoinDataModel] = newCoins.reduce(into: [:]) { result, coin in
            result[coin.id] = CoinDataModel(coin: coin)
        }
        
        appState.coinIdToData.merge(
            newData,
            uniquingKeysWith: { (_, new) in new }
        )
        
        appState.currentPage += 1
    }
    
    func shouldFetchMore(id: String) -> Bool {
        appState.coinIdsList.firstIndex(of: id) == appState.coinIdsList.count - threshold
    }
    
    func reset() {
        appState.coinIdsList = []
        appState.coinIdToData = [:]
        appState.didReachEnd = false
        appState.currentPage = 1
    }
}
