import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol FavoriteStore {
    func storeFavorite(_ entity: FavoriteEntity)
    func deleteFavorite(primaryKey: String)
    func favorites() -> Results<FavoriteEntity>
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

    func favorites() -> Results<FavoriteEntity> {
        realm.objects(FavoriteEntity.self)
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
            // If the Realm db is unable to be created, that's an unrecoverable error, so crashing the app is appropriate.
            // swiftlint:disable:next force_try
            let realm = try! Realm(fileURL: url!)
            return FavoriteStoreRealmImpl(realm: realm) as FavoriteStore
        }.scope(application)
    }
}
