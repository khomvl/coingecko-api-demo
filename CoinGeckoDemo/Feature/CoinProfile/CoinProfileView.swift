import SwiftUI
import Charts
import CoinGeckoAPI

struct CoinProfileView: View {
    var coinName: String
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @ObservedObject var chartViewModel: ChartViewModel
    @ObservedObject var detailsViewModel: CoinDetailListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                makeChart()
                    .onAppear {
                        chartViewModel.fetchCandlesData()
                    }
                
                Spacer()
                
                if isPortrait {
                    makeDetailsList()
                        .onAppear {
                            detailsViewModel.fetchCoinDetails()
                        }
                }
            }
            .navigationTitle(coinName)
        }
    }
    
    private var isPortrait: Bool {
        horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
}

private extension CoinProfileView {
    @ViewBuilder var chartOverlay: some View {
        if chartViewModel.timeoutExceeded {
            VStack(spacing: 8) {
                Text("Failed to load chart")
                    .font(.callout)
                    .foregroundColor(.candleRed)
                Button {
                    chartViewModel.fetchCandlesData()
                    detailsViewModel.fetchCoinDetails()
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .font(.body.bold())
                }
            }
        } else {
            // TODO: replace with shimmer
            if chartViewModel.candles.isEmpty {
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
            ForEach(chartViewModel.candles) { candle in
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
        List {
            ForEach(detailsViewModel.details) { detail in
                // TODO: make shimmer
                
                CoinDetailView(title: detail.title) {
                    Text(detail.value)
                        .font(.subheadline.bold())
                }
            }
        }
    }
}

struct CoinProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CoinProfileView(
            coinName: "BTC",
            chartViewModel: ChartViewModel(coinId: "bitcoin"),
            detailsViewModel: CoinDetailListViewModel(coinId: "bitcoin", currency: .usd)
        )
    }
}
