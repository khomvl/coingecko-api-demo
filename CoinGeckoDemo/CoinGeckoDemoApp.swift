import SwiftUI
import CoinGeckoAPI

@main
struct CoinGeckoDemoApp: App {
    init() {
        DIContainer.shared.register(
            type: APIClient.self,
            dependency: CoinGeckoAPIClient(baseUrl: URL(string: "https://api.coingecko.com/")!)
        )
    }
    
    var body: some Scene {
        WindowGroup {
            CoinListView(viewModel: CoinListViewModel())
        }
    }
}
