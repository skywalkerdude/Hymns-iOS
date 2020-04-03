import Resolver

/**
 * Registers repositories to the dependency injection framework.
 */
extension Resolver: ResolverRegistering {
    public static func registerRepositories() {
        register {HymnsRepositoryImpl(hymnalApiService: resolve()) as HymnsRepository}.scope(application)
    }
}
