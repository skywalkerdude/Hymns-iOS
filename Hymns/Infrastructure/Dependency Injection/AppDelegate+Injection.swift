import Resolver
import Foundation
/**
 * Registers dependencies to be injected in the app
 */
extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register(name: "main") { DispatchQueue.main }
        register(name: "background") { DispatchQueue(label: "background") }
        registerHymnalApiService()
        registerRepositories()
        registerHomeViewModel()
        registerSearchViewModel()
    }
}
