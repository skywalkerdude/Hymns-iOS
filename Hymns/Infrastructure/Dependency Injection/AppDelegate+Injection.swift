import Resolver

/**
 * Registers dependencies to be injected in the app
 */
extension Resolver {
    public static func registerAllServices() {
        register(name: "main") { DispatchQueue.main }
        registerHymnalApiService()
        registerRepositories()
        registerHomeViewModel()
    }
}
