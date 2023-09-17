import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private var container: [String: Any] = [:]
    
    private init() { }
    
    func register<T>(type: T.Type, dependency: Any) {
        container["\(type)"] = dependency
    }
    
    func resolve<T>(type: T.Type) -> T {
        guard let dependency = container["\(type)"] as? T else {
            fatalError("Dependency \(type) had not been registered")
        }
        
        return dependency
    }
}
