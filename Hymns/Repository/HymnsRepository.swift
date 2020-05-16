import Combine
import FirebaseCrashlytics
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
    private let mainQueue: DispatchQueue
    private let service: HymnalApiService
    private let systemUtil: SystemUtil

    private var disposables = Set<AnyCancellable>()
    private var hymns: [HymnIdentifier: UiHymn] = [HymnIdentifier: UiHymn]()

    init(converter: Converter = Resolver.resolve(),
         dataStore: HymnDataStore = Resolver.resolve(),
         decoder: JSONDecoder = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main"),
         service: HymnalApiService = Resolver.resolve(),
         systemUtil: SystemUtil = Resolver.resolve()) {
        self.converter = converter
        self.dataStore = dataStore
        self.decoder = decoder
        self.mainQueue = mainQueue
        self.service = service
        self.systemUtil = systemUtil
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier)  -> AnyPublisher<UiHymn?, Never> {
        if let hymn = hymns[hymnIdentifier] {
            return Just(hymn).eraseToAnyPublisher()
        }

        return HymnPublisher(hymnIdentifier: hymnIdentifier, disposables: &disposables, converter: converter,
                             dataStore: dataStore, service: service, systemUtil: systemUtil)
            .replaceError(with: nil)
            .map { hymn -> UiHymn? in
                guard let hymn = hymn else {
                    return nil
                }
                self.mainQueue.async {
                    self.hymns[hymnIdentifier] = hymn
                }
                return hymn
        }.eraseToAnyPublisher()
    }

    fileprivate class HymnPublisher: NetworkBoundPublisher {

        // swiftlint:disable nesting
        typealias UIResultType = UiHymn?
        typealias Output = UiHymn?
        // swiftlint:enable nesting

        private var disposables: Set<AnyCancellable>
        private let converter: Converter
        private let dataStore: HymnDataStore
        private let hymnIdentifier: HymnIdentifier
        private let service: HymnalApiService
        private let systemUtil: SystemUtil

        init(hymnIdentifier: HymnIdentifier, disposables: inout Set<AnyCancellable>, converter: Converter,
             dataStore: HymnDataStore, service: HymnalApiService, systemUtil: SystemUtil) {
            self.disposables = disposables
            self.converter = converter
            self.dataStore = dataStore
            self.hymnIdentifier = hymnIdentifier
            self.service = service
            self.systemUtil = systemUtil
        }

        func createSubscription<S>(_ subscriber: S) -> Subscription where S: Subscriber, S.Failure == ErrorType, S.Input == UIResultType {
            HymnSubscription(hymnIdentifier: hymnIdentifier, converter: converter, dataStore: dataStore,
                             disposables: &disposables, service: service, subscriber: subscriber, systemUtil: systemUtil)
        }
    }

    fileprivate class HymnSubscription<SubscriberType: Subscriber>: NetworkBoundSubscription
        where SubscriberType.Input == UiHymn?, SubscriberType.Failure == ErrorType {

        private let analytics: AnalyticsLogger
        private let converter: Converter
        private let dataStore: HymnDataStore
        private let hymnIdentifier: HymnIdentifier
        private let service: HymnalApiService
        private let systemUtil: SystemUtil

        private var disposables: Set<AnyCancellable>

        var subscriber: SubscriberType?

        fileprivate init(hymnIdentifier: HymnIdentifier, analytics: AnalyticsLogger = Resolver.resolve(),
                         converter: Converter, dataStore: HymnDataStore, disposables: inout Set<AnyCancellable>,
                         service: HymnalApiService, subscriber: SubscriberType, systemUtil: SystemUtil) {
            // okay to inject analytics because wse aren't mocking it in the unit tests
            self.analytics = analytics
            self.converter = converter
            self.dataStore = dataStore
            self.disposables = disposables
            self.hymnIdentifier = hymnIdentifier
            self.service = service
            self.subscriber = subscriber
            self.systemUtil = systemUtil
        }

        func request(_ demand: Subscribers.Demand) {
            // Optionaly Adjust The Demand
            execute(disposables: &disposables)
        }

        func saveToDatabase(convertedNetworkResult: HymnEntity?) {
            if !dataStore.databaseInitializedProperly {
                return
            }
            guard let hymnEntity = convertedNetworkResult else {
                return
            }
            dataStore.saveHymn(hymnEntity)
        }

        func shouldFetch(convertedDatabaseResult: UiHymn??) -> Bool {
            let flattened = convertedDatabaseResult?.flatMap({ uiHymn -> UiHymn? in
                return uiHymn
            })
            return systemUtil.isNetworkAvailable() && flattened == nil
        }

        /**
         * Converts the network result to the equivalent database result type.
         */
        func convertType(networkResult: Hymn) throws -> HymnEntity? {
            do {
                return try converter.toHymnEntity(hymnIdentifier: hymnIdentifier, hymn: networkResult)
            } catch {
                analytics.logError(message: "error orccured when converting Hymn to HymnEntity", error: error, extraParameters: ["hymnIdentifier": String(describing: hymnIdentifier)])
                throw TypeConversionError(triggeringError: error)
            }
        }

        /**
         * Converts the database result to the type consumed by the UI.
         */
        func convertType(databaseResult: HymnEntity?) throws -> UiHymn? {
            do {
                return try converter.toUiHymn(hymnIdentifier: hymnIdentifier, hymnEntity: databaseResult)
            } catch {
                analytics.logError(message: "error orccured when converting HymnEntity to UiHymn", error: error, extraParameters: ["hymnIdentifier": String(describing: hymnIdentifier)])
                throw TypeConversionError(triggeringError: error)
            }
        }

        func loadFromDatabase() -> AnyPublisher<HymnEntity?, ErrorType> {
            if !dataStore.databaseInitializedProperly {
                return Just<HymnEntity?>(nil).tryMap { _ -> HymnEntity? in
                    throw ErrorType.data(description: "database was not intialized properly")
                }.mapError({ error -> ErrorType in
                    ErrorType.data(description: error.localizedDescription)
                }).eraseToAnyPublisher()
            }
            return dataStore.getHymn(hymnIdentifier)
        }

        func createNetworkCall() -> AnyPublisher<Hymn, ErrorType> {
            service.getHymn(hymnIdentifier)
        }
    }
}
