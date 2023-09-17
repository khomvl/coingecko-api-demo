import Foundation

protocol URLRequestBuildable {
    func get(_ url: URL, queryItems: [URLQueryItem]?) -> URLRequest
    // post etc
}

extension URLRequestBuildable {
    func get(_ url: URL, queryItems: [URLQueryItem]? = nil) -> URLRequest {
        guard let queryItems, !queryItems.isEmpty else {
            return URLRequest(url: url)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        
        guard let queryURL = components?.url else {
            return URLRequest(url: url)
        }

        return URLRequest(url: queryURL)
    }
}
