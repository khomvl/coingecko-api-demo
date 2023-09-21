import CoinGeckoAPI

struct MarketCapRankVisitor: PropertyVisitor {
    func visit(_ data: CoinDataModel) -> CoinDetailViewModel {
        .init(
            title: "Market Cap Rank",
            value: {
                guard let rank = data.marketCapRank else {
                    return "—"
                }
                return "#\(rank)"
            }()
        )
    }
}
