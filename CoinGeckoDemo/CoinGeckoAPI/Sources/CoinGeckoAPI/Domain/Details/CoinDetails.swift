import Foundation

public struct CoinDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case marketData
    }
    
    enum MarketDataCodingKeys: String, CodingKey {
        case currentPrice
        case priceChangePercentage24HInCurrency
        case allTimeHigh = "ath"
        case allTimeLow = "atl"
        case marketCap
        case marketCapRank
        case totalVolume
        case high24H
        case low24H
    }
    
    public let id: String
    public let name: String
    public let marketCapRank: Int
    
    let currentPrice: [String: Decimal]
    let priceChangePercentage24HInCurrency: [String: Decimal]
    let allTimeHigh: [String: Decimal]
    let allTimeLow: [String: Decimal]
    let marketCap: [String: Decimal]
    let totalVolume: [String: Decimal]
    let high24H: [String: Decimal]
    let low24H: [String: Decimal]
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let marketDataContainer = try rootContainer.nestedContainer(keyedBy: MarketDataCodingKeys.self, forKey: .marketData)
        
        self.id = try rootContainer.decode(String.self, forKey: .id)
        self.name = try rootContainer.decode(String.self, forKey: .name)
        self.marketCapRank = try marketDataContainer.decode(Int.self, forKey: .marketCapRank)
        self.priceChangePercentage24HInCurrency = try marketDataContainer.decode([String: Decimal].self, forKey: .priceChangePercentage24HInCurrency)
        
        self.currentPrice = try marketDataContainer.decode([String: Decimal].self, forKey: .currentPrice)
        self.allTimeHigh = try marketDataContainer.decode([String: Decimal].self, forKey: .allTimeHigh)
        self.allTimeLow = try marketDataContainer.decode([String: Decimal].self, forKey: .allTimeLow)
        self.marketCap = try marketDataContainer.decode([String: Decimal].self, forKey: .marketCap)
        self.totalVolume = try marketDataContainer.decode([String: Decimal].self, forKey: .totalVolume)
        self.high24H = try marketDataContainer.decode([String: Decimal].self, forKey: .high24H)
        self.low24H = try marketDataContainer.decode([String: Decimal].self, forKey: .low24H)
    }
    
    public func currentPrice(in currency: Currency) -> Decimal? {
        currentPrice[currency.rawValue]
    }
    
    public func priceChangePercentage24H(in currency: Currency) -> Decimal? {
        priceChangePercentage24HInCurrency[currency.rawValue]
    }
    
    public func allTimeHigh(in currency: Currency) -> Decimal? {
        allTimeHigh[currency.rawValue]
    }
    
    public func allTimeLow(in currency: Currency) -> Decimal? {
        allTimeLow[currency.rawValue]
    }
    
    public func marketCap(in currency: Currency) -> Decimal? {
        marketCap[currency.rawValue]
    }
    
    public func totalVolume(in currency: Currency) -> Decimal? {
        totalVolume[currency.rawValue]
    }
    
    public func high24H(in currency: Currency) -> Decimal? {
        high24H[currency.rawValue]
    }
    
    public func low24H(in currency: Currency) -> Decimal? {
        low24H[currency.rawValue]
    }
}
