import SwiftUI
import CoinGeckoAPI

struct CoinListView: View {
    @ObservedObject var viewModel: CoinListViewModel
    @State var showErrorToast: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.coins.isEmpty {
                    ForEach((1...12), id: \.self) { _ in
                        CoinListItemShimmerView()
                    }
                } else {
                    ForEach(viewModel.coins.map {
                        CoinListItemViewModel(coin: $0, currency: viewModel.currency)
                    }) { viewModel in
                        NavigationLink {
                            CoinProfileView(
                                coinName: viewModel.title,
                                chartViewModel: ChartViewModel(
                                    coinId: viewModel.id
                                ),
                                detailsViewModel: CoinDetailListViewModel(
                                    coinId: viewModel.id,
                                    currency: self.viewModel.currency
                                )
                            )
                        } label: {
                            CoinListItemView(viewModel: viewModel)
                                .task {
                                    guard self.viewModel.shouldFetchMore(id: viewModel.id) else {
                                        return
                                    }
                                    self.viewModel.fetchMoreCoins()
                                }
                        }
                    }
                }
            }
            .refreshable {
                viewModel.reset()
            }
            .task {
                viewModel.fetchMoreCoins()
            }
            .navigationTitle("Coins")
        }
        .overlay {
            VStack {
                ErrorToast(error: $viewModel.error)
                    .offset(y: showErrorToast ? 0 : -200)
                    .onTapGesture {
                        withAnimation {
                            self.showErrorToast = false
                        }
                    }
                Spacer()
            }
        }
        .onReceive(viewModel.$error) { output in
            guard output != nil else {
                return
            }
            
            withAnimation {
                showErrorToast = true
                
            }
            Task.delayed(byTimeInterval: 2) { @MainActor in
                withAnimation {
                    showErrorToast = false
                }
            }
        }
    }
}

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView(viewModel: CoinListViewModel())
    }
}
