public protocol APIClient {
    func request<E: Endpoint>(endpoint: E) async throws -> E.ResponseType
    func addInterceptor(_ interceptor: URLRequestInterceptor)
}
