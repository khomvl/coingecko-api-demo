import CoinGeckoAPI

struct MarketCapRankVisitor: PropertyVisitor {
    func visit(_ data: CoinDetails) -> CoinDetailViewModel {
        .init(
            title: "Market Cap Rank",
            value: "#\(data.marketCapRank)"
        )
    }
}
