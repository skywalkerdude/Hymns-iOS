import Resolver
import Foundation
/**
 * Registers dependencies to be injected in the app
 */
extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerApplication()
        register(name: "main") { DispatchQueue.main }
        register(name: "background") { DispatchQueue(label: "background") }
        registerHistoryStore()
        registerFavoritesStore()
        registerHymnalApiService()
        registerRepositories()
        registerHomeViewModel()
        registerFavoritesViewModel()
        registerSettingsViewModel()
    }
}
