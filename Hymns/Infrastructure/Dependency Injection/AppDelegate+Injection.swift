import Resolver
import Foundation
/**
 * Registers dependencies to be injected in the app
 */
extension Resolver: ResolverRegistering {

    #if DEBUG
    static let mock = Resolver(parent: main)
    #endif

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
        registerHymnalNetService()
        registerRepositories()
        registerHomeViewModel()
        registerBrowseViewModel()
        registerTagListViewModel()
        registerFavoritesViewModel()
        registerSettingsViewModel()

        #if DEBUG
        if CommandLine.arguments.contains(AppDelegate.uiTestingFlag) {
            mock.register { FavoriteStoreTestImpl() as FavoriteStore }.scope(application)
            mock.register { HymnDataStoreTestImpl() as HymnDataStore }.scope(application)
            mock.register { HistoryStoreTestImpl() as HistoryStore }.scope(application)
            mock.register { TagStoreTestImpl() as TagStore }.scope(application)
            root = mock
        }
        #endif
    }
}
