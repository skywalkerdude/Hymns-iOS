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
        register {URLSession.shared}.scope(application)
        register {UserDefaultsManager()}.scope(application)
        register {AnalyticsLogger()}
        register {SystemUtil()}
        registerPDFLoader()
        registerConverters()
        registerHymnDataStore()
        registerHistoryStore()
        registerTagStore()
        registerFavoriteStore()
        registerHymnalApiService()
        registerRepositories()
        registerHomeViewModel()
        registerFavoritesViewModel()
        registerSettingsViewModel()
    }
}
