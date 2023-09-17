import Foundation

final class BaseURLInterceptor: URLRequestInterceptor {
    private let baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func intercept(_ urlRequest: inout URLRequest) {
        guard let url = urlRequest.url else {
            return
        }
        
        urlRequest.url = URL(string: "api/v3/\(url.absoluteString)", relativeTo: baseUrl)!
    }
}
