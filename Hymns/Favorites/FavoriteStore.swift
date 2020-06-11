import Combine
import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol FavoriteStore {
    func storeFavorite(_ entity: FavoriteEntity)
    func deleteFavorite(primaryKey: String)
    func favorites() -> AnyPublisher<[FavoriteEntity], ErrorType>
    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool
    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification
}

class FavoriteStoreRealmImpl: FavoriteStore {

    private let analytics: AnalyticsLogger
    private let realm: Realm

    init(analytics: AnalyticsLogger = Resolver.resolve(), realm: Realm) {
        self.analytics = analytics
        self.realm = realm
    }

    func storeFavorite(_ entity: FavoriteEntity) {
        do {
            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            analytics.logError(message: "error orccured when storing favorite", error: error, extraParameters: ["primaryKey": entity.primaryKey])
        }
    }

    func deleteFavorite(primaryKey: String) {
        guard let entityToDelete = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: primaryKey) else {
            analytics.logError(message: "tried to delete a favorite that doesn't exist", extraParameters: ["primaryKey": primaryKey])
            return
        }

        do {
            try realm.write {
                realm.delete(entityToDelete)
            }
        } catch {
            analytics.logError(message: "error orccured when deleting favorite", error: error, extraParameters: ["primaryKey": primaryKey])
        }
    }

    func favorites() -> AnyPublisher<[FavoriteEntity], ErrorType> {
        realm.objects(FavoriteEntity.self).publisher
            .map({ results -> [FavoriteEntity] in
                results.map { entity -> FavoriteEntity in
                    entity
                }
            }).mapError({ error -> ErrorType in
                .data(description: error.localizedDescription)
            }).eraseToAnyPublisher()
    }

    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool {
        return realm.object(ofType: FavoriteEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier)) != nil
    }

    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification {
        return realm.observe { (_, _) in
            let favorite = self.isFavorite(hymnIdentifier: hymnIdentifier)
            action(favorite)
        }.toNotification()
    }
}

extension Resolver {
    public static func registerFavoriteStore() {
        register(FavoriteStore.self) {
            // https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file
            var url = Realm.Configuration.defaultConfiguration.fileURL
            url?.deleteLastPathComponent()
            url?.appendPathComponent("favorites.realm")
            let config = Realm.Configuration(
                fileURL: url!,
                // Set the new schema version. This must be greater than the previously used
                // version (if you've never set a schema version before, the version is 0).
                schemaVersion: 0,

                // Set the block which will be called automatically when opening a Realm with
                // a schema version lower than the one set above
                migrationBlock: { _, _ in
                    // We haven’t migrated anything yet, so oldSchemaVersion == 0
            })
            // If the Realm db is unable to be created, that's an unrecoverable error, so crashing the app is appropriate.
            // swiftlint:disable:next force_try
            let realm = try! Realm(configuration: config)
            return FavoriteStoreRealmImpl(realm: realm) as FavoriteStore
        }.scope(application)
    }
}
