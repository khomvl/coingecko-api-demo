import Foundation

public struct Coin: Decodable {
    public let id: String
    public let symbol: String
    public let name: String
    public let image: URL
    public let currentPrice: Decimal
    public let priceChangePercentage24H: Decimal
}
