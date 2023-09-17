import Foundation

public struct CoinDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case marketData
    }
    
    enum MarketDataCodingKeys: String, CodingKey {
        case currentPrice
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
    
    let currentPrice: [String: Double]
    let allTimeHigh: [String: Double]
    let allTimeLow: [String: Double]
    let marketCap: [String: Double]
    let totalVolume: [String: Double]
    let high24H: [String: Double]
    let low24H: [String: Double]
    
    public init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let marketDataContainer = try rootContainer.nestedContainer(keyedBy: MarketDataCodingKeys.self, forKey: .marketData)
        
        self.id = try rootContainer.decode(String.self, forKey: .id)
        self.name = try rootContainer.decode(String.self, forKey: .name)
        self.marketCapRank = try marketDataContainer.decode(Int.self, forKey: .marketCapRank)
        
        self.currentPrice = try marketDataContainer.decode([String: Double].self, forKey: .currentPrice)
        self.allTimeHigh = try marketDataContainer.decode([String: Double].self, forKey: .allTimeHigh)
        self.allTimeLow = try marketDataContainer.decode([String: Double].self, forKey: .allTimeLow)
        self.marketCap = try marketDataContainer.decode([String: Double].self, forKey: .marketCap)
        self.totalVolume = try marketDataContainer.decode([String: Double].self, forKey: .totalVolume)
        self.high24H = try marketDataContainer.decode([String: Double].self, forKey: .high24H)
        self.low24H = try marketDataContainer.decode([String: Double].self, forKey: .low24H)
    }
    
    public func currentPrice(in currency: Currency) -> Double? {
        currentPrice[currency.rawValue]
    }
    
    public func allTimeHigh(in currency: Currency) -> Double? {
        allTimeHigh[currency.rawValue]
    }
    
    public func allTimeLow(in currency: Currency) -> Double? {
        allTimeLow[currency.rawValue]
    }
    
    public func marketCap(in currency: Currency) -> Double? {
        marketCap[currency.rawValue]
    }
    
    public func totalVolume(in currency: Currency) -> Double? {
        totalVolume[currency.rawValue]
    }
    
    public func high24H(in currency: Currency) -> Double? {
        high24H[currency.rawValue]
    }
    
    public func low24H(in currency: Currency) -> Double? {
        low24H[currency.rawValue]
    }
}
