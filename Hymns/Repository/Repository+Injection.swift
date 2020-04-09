import Resolver

/**
 * Registers repositories to the dependency injection framework.
 */
extension Resolver {
    public static func registerRepositories() {
        register {HymnsRepositoryImpl(hymnalApiService: resolve()) as HymnsRepository}.scope(application)
        register {SongResultsRepositoryImpl(hymnalApiService: resolve()) as SongResultsRepository}.scope(application)
    }
}
