import Foundation

public extension Details {
    struct Endpoint {
        public let id: String
        
        public init(id: String) {
            self.id = id
        }
    }
}

extension Details.Endpoint: Endpoint, URLRequestBuildable {
    public typealias ResponseType = CoinDetails
    
    public func makeRequest() throws -> URLRequest {
        get(URL(string: "/coins/\(id)")!, queryItems: [
            // in order to reduce traffic
            .init(name: "tickers", value: "false"),
            .init(name: "community_data", value: "false"),
            .init(name: "developer_data", value: "false"),
            .init(name: "sparkline", value: "false"),
        ])
    }
    
    public func decode(from responseData: Data) throws -> ResponseType {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(ResponseType.self, from: responseData)
    }
}
