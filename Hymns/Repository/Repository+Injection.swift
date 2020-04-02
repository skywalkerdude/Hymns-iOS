import Resolver

/**
 * Registers repositories to the dependency injection framework.
 */
extension Resolver: ResolverRegistering {
    public static func registerRepositories() {
        register {HymnsRepository()}.scope(application)
    }
}
