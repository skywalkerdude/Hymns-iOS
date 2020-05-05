import Combine
import Foundation
import Resolver

/**
 * Repository that stores all hymns that have been searched during this session in memory.
 */
protocol HymnsRepository {
    func getHymn(_ hymnIdentifier: HymnIdentifier)  -> AnyPublisher<UiHymn?, Never>
}

class HymnsRepositoryImpl: HymnsRepository {

    private let converter: Converter
    private let dataStore: HymnDataStore
    private let decoder: JSONDecoder
    private let queue: DispatchQueue
    private let service: HymnalApiService
    private let systemUtil: SystemUtil

    private var disposables = Set<AnyCancellable>()
    private var hymns: [HymnIdentifier: UiHymn] = [HymnIdentifier: UiHymn]()

    init(converter: Converter = Resolver.resolve(),
         dataStore: HymnDataStore = Resolver.resolve(),
         decoder: JSONDecoder = Resolver.resolve(),
         queue: DispatchQueue = Resolver.resolve(name: "background"),
         service: HymnalApiService = Resolver.resolve(),
         systemUtil: SystemUtil = Resolver.resolve()) {
        self.converter = converter
        self.dataStore = dataStore
        self.decoder = decoder
        self.queue = queue
        self.service = service
        self.systemUtil = systemUtil
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier)  -> AnyPublisher<UiHymn?, Never> {
        if let hymn = hymns[hymnIdentifier] {
            return Just(hymn).eraseToAnyPublisher()
        }

        return HymnNetworkBoundResource(
            converter: converter, dataStore: dataStore, decoder: decoder, disposables: disposables,
            hymnIdentifier: hymnIdentifier, service: service, systemUtil: systemUtil)
            .execute(disposables: &disposables)
            .receive(on: queue)
            .map { [weak self] resource -> UiHymn? in
                guard let hymn = resource.data else {
                    return nil
                }

                self?.hymns[hymnIdentifier] = hymn
                return hymn
        }
        .replaceError(with: nil)
        .eraseToAnyPublisher()
    }

    fileprivate struct HymnNetworkBoundResource: NetworkBoundResource {

        private let converter: Converter
        private let dataStore: HymnDataStore
        private let decoder: JSONDecoder
        private let hymnIdentifier: HymnIdentifier
        private let service: HymnalApiService
        private let systemUtil: SystemUtil

        let disposables: Set<AnyCancellable>

        fileprivate init(converter: Converter, dataStore: HymnDataStore, decoder: JSONDecoder, disposables: Set<AnyCancellable>,
                         hymnIdentifier: HymnIdentifier, service: HymnalApiService, systemUtil: SystemUtil) {
            self.converter = converter
            self.dataStore = dataStore
            self.decoder = decoder
            self.disposables = disposables
            self.hymnIdentifier = hymnIdentifier
            self.service = service
            self.systemUtil = systemUtil
        }

        func saveToDatabase(convertedNetworkResult: HymnEntity) {
            dataStore.saveHymn(convertedNetworkResult)
        }

        func shouldFetch(uiResult: UiHymn?) -> Bool {
            return systemUtil.isNetworkAvailable() && uiResult == nil
        }

        func convertType(networkResult: Hymn) throws -> HymnEntity? {
            do {
                return try converter.toHymnEntity(hymnIdentifier: hymnIdentifier, hymn: networkResult)
            } catch {
                // TODO Firebase non-fatal
                throw TypeConversionError(triggeringError: error)
            }
        }

        /**
         * Converts the network result to the database result type and combines them together.
         */
        func convertType(databaseResult: HymnEntity?) throws -> UiHymn? {
            do {
                return try converter.toUiHymn(hymnIdentifier: hymnIdentifier, hymnEntity: databaseResult)
            } catch {
                // TODO Firebase non-fatal
                throw TypeConversionError(triggeringError: error)
            }
        }

        func loadFromDatabase() -> AnyPublisher<HymnEntity?, ErrorType> {
            return dataStore.getHymn(hymnIdentifier)
        }

        func createNetworkCall() -> AnyPublisher<Hymn, ErrorType> {
            return service.getHymn(hymnIdentifier)
        }
    }
}
