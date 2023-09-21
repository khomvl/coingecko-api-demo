import CoinGeckoAPI

struct CoinProfileInteractor {
    private let coinId: String
    private let appState: AppState
    private let apiClient: APIClient
    
    init(
        coinId: String,
        appState: AppState = DIContainer.shared.resolve(type: AppState.self),
        apiClient: APIClient = DIContainer.shared.resolve(type: APIClient.self)
    ) {
        self.coinId = coinId
        self.appState = appState
        self.apiClient = apiClient
    }
    
    var selectedCoin: CoinDataModel? {
        appState.coinIdToData[coinId]
    }
    
    @MainActor
    func fetchCoinDetails() async throws {
        let endpoint = Details.Endpoint(id: coinId)
        let details = try await apiClient.request(endpoint: endpoint)
        
        appState.coinIdToData[coinId]?.enrich(
            with: details,
            currency: appState.currency
        )
    }
    
    @MainActor
    func fetchChartData() async throws {
        let endpoint = Chart.Endpoint(coinId: coinId)
        let candles = try await apiClient.request(endpoint: endpoint)
        
        appState.coinIdToData[coinId]?.enrich(with: candles)
    }
}
