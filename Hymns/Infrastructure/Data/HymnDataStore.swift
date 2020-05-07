import FirebaseCrashlytics
import Combine
import Foundation
import GRDB
import Resolver

/**
 * Service to contact the local Hymn database.
 */
protocol HymnDataStore {
    func saveHymn(_ entity: HymnEntity)
    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType>
}

/**
 * Implementation of `HymnDataStore` that uses `GRDB`.
 */
class HymnDataStoreGrdbImpl: HymnDataStore {

    private let backgroundQueue: DispatchQueue
    private let databaseQueue: DatabaseQueue

    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"), databaseQueue: DatabaseQueue) {
        self.backgroundQueue = backgroundQueue
        self.databaseQueue = databaseQueue
    }

    func saveHymn(_ entity: HymnEntity) {
        backgroundQueue.async {
            do {
                try self.databaseQueue.inDatabase { database in
                    try entity.insert(database)
                }
            } catch {
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType> {
        let hymnType = hymnIdentifier.hymnType.abbreviatedValue
        let hymnNumber = hymnIdentifier.hymnNumber
        let queryParams = hymnIdentifier.queryParamString

        let passThrough = PassthroughSubject<HymnEntity?, ErrorType>()
        backgroundQueue.async {
            do {
                let hymnEntity = try self.databaseQueue.inDatabase { database in
                    try HymnEntity.fetchOne(database,
                                            sql: "SELECT * FROM SONG_DATA WHERE HYMN_TYPE = ? AND HYMN_NUMBER = ? AND QUERY_PARAMS = ?",
                                            arguments: [hymnType, hymnNumber, queryParams])
                }
                passThrough.send(hymnEntity)
            } catch {
                passThrough.send(completion: .failure(.data(description: error.localizedDescription)))
            }
        }
        return passThrough.eraseToAnyPublisher()
    }
}

extension Resolver {
    public static func registerHymnDataStore() {
        register(HymnDataStore.self) {
            // If the databse queue is unable to be created, that's an unrecoverable error, so crashing the app is appropriate.
            // swiftlint:disable:next force_try
            let databaseQueue = try! DatabaseQueue(path: Bundle.main.url(forResource: "hymnaldb-v12", withExtension: "")!.absoluteString)
            return HymnDataStoreGrdbImpl(databaseQueue: databaseQueue) as HymnDataStore
        }.scope(application)
    }
}
