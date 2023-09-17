import Foundation

public struct APIError: Decodable, LocalizedError {
    public struct Status: Decodable {
        public let errorCode: Int
        public let errorMessage: String
    }
    
    public let status: Status
    
    public var errorDescription: String {
        status.errorMessage
    }
}
