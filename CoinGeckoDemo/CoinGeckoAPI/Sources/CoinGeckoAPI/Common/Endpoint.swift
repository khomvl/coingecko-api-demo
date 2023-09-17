import Foundation

public protocol Endpoint {
    associatedtype ResponseType
    
    func makeRequest() throws -> URLRequest
    func decode(from responseData: Data) throws -> ResponseType
}
