import Foundation

public protocol URLRequestInterceptor {
    func intercept(_ urlRequest: inout URLRequest)
}
