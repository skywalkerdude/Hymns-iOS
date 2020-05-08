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

    private let databaseQueue: DatabaseQueue

    init(databaseQueue: DatabaseQueue) {
        self.databaseQueue = databaseQueue
    }

    func saveHymn(_ entity: HymnEntity) {
        do {
            try self.databaseQueue.inDatabase { database in
                try entity.insert(database)
            }
        } catch {
            Crashlytics.crashlytics().record(error: error)
        }
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType> {
        let hymnType = hymnIdentifier.hymnType.abbreviatedValue
        let hymnNumber = hymnIdentifier.hymnNumber
        let queryParams = hymnIdentifier.queryParamString

        let publisher = CurrentValueSubject<HymnEntity?, ErrorType>(nil)
        do {
            let hymnEntity = try self.databaseQueue.inDatabase { database -> HymnEntity? in
                return try HymnEntity.fetchOne(database,
                                               sql: "SELECT * FROM SONG_DATA WHERE HYMN_TYPE = ? AND HYMN_NUMBER = ? AND QUERY_PARAMS = ?",
                                               arguments: [hymnType, hymnNumber, queryParams])
            }
            publisher.send(hymnEntity)
        } catch {
            publisher.send(completion: .failure(.data(description: error.localizedDescription)))
        }
        return publisher.eraseToAnyPublisher()
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
