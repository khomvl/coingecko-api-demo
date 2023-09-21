import SwiftUI
import CoinGeckoAPI

@main
struct CoinGeckoDemoApp: App {
    init() {
        DIContainer.shared.register(
            type: APIClient.self,
            dependency: CoinGeckoAPIClient(baseUrl: URL(string: "https://api.coingecko.com/")!)
        )
        DIContainer.shared.register(
            type: AppState.self,
            dependency: AppState()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            CoinListView(interactor: CoinListInteractor())
                .environmentObject(DIContainer.shared.resolve(type: AppState.self))
        }
    }
}
