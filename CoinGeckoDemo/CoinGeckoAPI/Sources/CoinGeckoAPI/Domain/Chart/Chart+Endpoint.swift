import Foundation

public extension Chart {
    enum Timeframe: String {
        case days1 = "1"
        case days30 = "30"
        case max = "max"
    }
    
    struct Endpoint {
        public let coinId: String
        public let vsCurrency: Currency
        public let timeframe: Timeframe
        
        public init(coinId: String, vsCurrency: Currency = .usd, timeframe: Timeframe = .days1) {
            self.coinId = coinId
            self.vsCurrency = vsCurrency
            self.timeframe = timeframe
        }
    }
}

extension Chart.Endpoint: Endpoint, URLRequestBuildable {
    public typealias ResponseType = [CandleData]
    
    public func makeRequest() throws -> URLRequest {
        get(URL(string: "/coins/\(coinId)/ohlc")!, queryItems: [
            .init(name: "vs_currency", value: "\(vsCurrency.rawValue)"),
            .init(name: "days", value: timeframe.rawValue)
        ])
    }
    
    public func decode(from responseData: Data) throws -> ResponseType {
        let rawData = try JSONDecoder().decode([[Double]].self, from: responseData)
        return rawData
            .map { rawCandle in
                .init(
                    timestamp: Date(timeIntervalSince1970: (rawCandle[safe: 0] ?? 0.0) / 1000),
                    open: rawCandle[safe: 1] ?? 0.0,
                    high: rawCandle[safe: 2] ?? 0.0,
                    low: rawCandle[safe: 3] ?? 0.0,
                    close: rawCandle[safe: 4] ?? 0.0
                )
            }
    }
}

private extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
