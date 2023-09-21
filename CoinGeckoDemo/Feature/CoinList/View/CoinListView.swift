import SwiftUI
import CoinGeckoAPI

struct CoinListView: View {
    @EnvironmentObject var appState: AppState
    var interactor: CoinListInteractor
    @State var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            List {
                if appState.coinData.isEmpty {
                    makeSkeleton()
                } else {
                    makeListItems()
                }
            }
            .refreshable {
                interactor.reset()
                fetchMoreCoins()
            }
            .task {
                guard appState.coinData.isEmpty else {
                    return
                }
                
                fetchMoreCoins()
            }
            .navigationTitle("Coins")
        }
        .overlay(
            ErrorToast(
                errorMessage: $errorMessage
            )
        )
    }
}

private extension CoinListView {
    
    @ViewBuilder
    func makeSkeleton() -> some View {
        ForEach((1...12), id: \.self) { _ in
            CoinListItemShimmerView()
        }
    }
    
    @ViewBuilder
    func makeListItems() -> some View {
        ForEach(appState.coinData, id: \.id) { coinData in
            NavigationLink {
                CoinProfileView(
                    interactor: CoinProfileInteractor(coinId: coinData.id)
                )
            } label: {
                CoinListItemView(viewModel: .init(
                    coinData: coinData,
                    currency: appState.currency
                ))
                .task {
                    guard interactor.shouldFetchMore(id: coinData.id) else {
                        return
                    }
                    
                    fetchMoreCoins()
                }
            }
        }
    }
    
    func fetchMoreCoins() {
        Task {
            do {
                try await interactor.fetchMoreCoins()
            } catch {
                handleError(error)
                
                // retry
                Task.delayed(byTimeInterval: 60) { @MainActor in
                    fetchMoreCoins()
                }
            }
        }
    }
    
    func handleError(_ error: Error) {
        withAnimation {
            errorMessage = (error as? APIError)?.status.errorMessage ?? "Unknown error occurred"
            
            Task.delayed(byTimeInterval: 2) { @MainActor in
                withAnimation {
                    self.errorMessage = nil
                }
            }
        }
    }
}

struct CoinListView_Previews: PreviewProvider {
    static var appState = DIContainer.shared.resolve(type: AppState.self)

    static var previews: some View {
       CoinListView(interactor: CoinListInteractor())
            .environmentObject(appState)
    }
}
