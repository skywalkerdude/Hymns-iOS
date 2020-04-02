import Resolver

/**
 * Registers dependencies to be injected in the app
 */
extension Resolver {
    public static func registerAllServices() {
        registerHymnalApiService()
        registerRepositories()
        registerHymnLyricsViewModel()
    }
}
