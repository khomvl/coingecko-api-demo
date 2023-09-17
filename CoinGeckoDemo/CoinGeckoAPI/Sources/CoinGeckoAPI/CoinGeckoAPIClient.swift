import Foundation

public final class CoinGeckoAPIClient: APIClient {
    private let baseUrl: URL
    private let urlSession: URLSession
    private var interceptors: [URLRequestInterceptor]
    
    public init(baseUrl: URL, urlSession: URLSession = .shared, interceptors: [URLRequestInterceptor] = []) {
        self.baseUrl = baseUrl
        self.urlSession = urlSession
        self.interceptors = [
            [BaseURLInterceptor(baseUrl: baseUrl)],
            // header modifying, etc.
            interceptors
        ].flatMap { $0 }
    }
    
    public func request<E: Endpoint>(endpoint: E) async throws -> E.ResponseType {
        var request = try endpoint.makeRequest()
        interceptors.forEach { $0.intercept(&request) }
        let (data, _) = try await urlSession.data(for: request)
        do {
            return try endpoint.decode(from: data)
        } catch {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            throw try decoder.decode(APIError.self, from: data)
        }
    }
    
    public func addInterceptor(_ interceptor: URLRequestInterceptor) {
        interceptors.append(interceptor)
    }
}
