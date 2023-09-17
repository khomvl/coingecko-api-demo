import Foundation

public extension CoinList {
    struct Endpoint {
        public let page: Int
        public let perPage: Int
        public let vsCurrency: Currency
        
        public init(page: Int, perPage: Int, vsCurrency: Currency = .usd) {
            self.page = page
            self.perPage = perPage
            self.vsCurrency = vsCurrency
        }
    }
}

extension CoinList.Endpoint: Endpoint, URLRequestBuildable {
    public typealias ResponseType = [Coin]
    
    public func makeRequest() throws -> URLRequest {
        get(URL(string: "/coins/markets")!, queryItems: [
            .init(name: "page", value: "\(page)"),
            .init(name: "per_page", value: "\(perPage)"),
            .init(name: "vs_currency", value: "\(vsCurrency.rawValue)")
        ])
    }
    
    public func decode(from responseData: Data) throws -> ResponseType {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(ResponseType.self, from: responseData)
    }
}
