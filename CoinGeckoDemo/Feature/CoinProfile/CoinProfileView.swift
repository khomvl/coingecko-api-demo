import SwiftUI
import Charts
import CoinGeckoAPI

struct CoinProfileView: View {
    @EnvironmentObject var appState: AppState
    @State var failedToLoadChart = false
    
    var interactor: CoinProfileInteractor
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        NavigationStack {
            VStack {
                makeChart()
                    .task {
                        let timeoutTask = Task.delayed(byTimeInterval: 10) { @MainActor in
                            failedToLoadChart = true
                        }
                        
                        Task {
                            do {
                                try await interactor.fetchChartData()
                                timeoutTask.cancel()
                            } catch {
                                failedToLoadChart = true
                            }
                        }
                    }
                
                Spacer()
                
                if isPortrait {
                    makeDetailsList()
                        .task {
                            Task {
                                try await interactor.fetchCoinDetails()
                            }
                        }
                }
            }
            .navigationTitle(interactor.selectedCoin?.symbol.uppercased() ?? "")
        }
    }
    
    private var isPortrait: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
}

private extension CoinProfileView {
    @ViewBuilder var chartOverlay: some View {
        if failedToLoadChart {
            VStack(spacing: 8) {
                Text("Failed to load chart")
                    .font(.callout)
                    .foregroundColor(.candleRed)
                Button {
                    Task {
                        failedToLoadChart = false
                        try await interactor.fetchChartData()
                        try await interactor.fetchCoinDetails()
                    }
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .font(.body.bold())
                }
            }
        } else {
            // TODO: replace with shimmer
            if interactor.selectedCoin?.chartData.isEmpty == true {
                ProgressView()
                    .controlSize(.large)
            }
        }
    }
    
    func makeCandleMark(for candleData: CandleData) -> some ChartContent {
        let color: Color = {
            if candleData.open < candleData.close {
                return .candleGreen
            }
            if candleData.close < candleData.open {
                return .candleRed
            }
            return .gray
        }()
        
        return CandleMark(
            time: .value("time", candleData.timestamp),
            low: .value("low", candleData.low),
            high: .value("high", candleData.high),
            open: .value("open", candleData.open),
            close: .value("close", candleData.close),
            width: isPortrait ? 6 : 10
        )
        .foregroundStyle(color)
    }
    
    @ViewBuilder
    func makeChart() -> some View {
        Chart {
            ForEach(interactor.selectedCoin?.chartData ?? []) { candle in
                makeCandleMark(for: candle)
            }
        }
        .chartYScale(domain: .automatic(includesZero: false))
        .padding()
        .overlay {
            chartOverlay
        }
    }
    
    @ViewBuilder
    func makeDetailsList() -> some View {
        if let coin = interactor.selectedCoin {
            List {
                ForEach(CoinDetailListViewModel(coinData: coin, currency: appState.currency).details) { detail in
                    // TODO: make shimmer
                    
                    CoinDetailView(title: detail.title) {
                        Text(detail.value)
                            .font(.subheadline.bold())
                    }
                }
            }
        }
        
        EmptyView()
    }
}

struct CoinProfileView_Previews: PreviewProvider {
    static var appState: AppState = {
        let appState = AppState()
        appState.coinIdsList = ["bitcoin"]
        appState.coinIdToData = [
            "bitcoin": .init(
                id: "bitcoin",
                symbol: "btc",
                name: "Bitcoin",
                image: URL(string: "about:blank")!
            )
        ]
        
        return appState
    }()
    
    static var previews: some View {
        CoinProfileView(interactor: CoinProfileInteractor(coinId: "bitcoin", appState: appState))
            .environmentObject(appState)
    }
}
