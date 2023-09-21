import CoinGeckoAPI

extension CandleData: Identifiable {
    public var id: String {
        "\(timestamp)"
    }
}
