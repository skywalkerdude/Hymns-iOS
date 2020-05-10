import Resolver
import Foundation
/**
 * Registers dependencies to be injected in the app
 */
extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerApplication()
        register(name: "main") { DispatchQueue.main }
        register(name: "background") { DispatchQueue.global() }
        register(JSONDecoder.self, factory: {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        })
        register(JSONEncoder.self, factory: {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dataEncodingStrategy = .deferredToData
            encoder.nonConformingFloatEncodingStrategy = .throw
            return encoder
        })
        register {AnalyticsLogger()}
        register {SystemUtil()}
        registerConverters()
        registerHymnDataStore()
        registerHistoryStore()
        registerFavoritesStore()
        registerHymnalApiService()
        registerWebViewPreloader()
        registerRepositories()
        registerHomeViewModel()
        registerFavoritesViewModel()
        registerSettingsViewModel()
    }
}
