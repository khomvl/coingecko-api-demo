import Foundation

public struct CandleData: Decodable {
    public let timestamp: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    
    public init(timestamp: Date, open: Double, high: Double, low: Double, close: Double) {
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
    
    public static let zero = CandleData(
        timestamp: Date(timeIntervalSince1970: 0),
        open: 0,
        high: 0,
        low: 0,
        close: 0
    )
}
