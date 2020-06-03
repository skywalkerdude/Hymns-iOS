import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol FavoritesStore {
    func storeFavorite(_ entity: FavoriteEntity)

    func unstoreFavorite(_ entity: FavoriteEntity)

    func deleteFavorite(primaryKey: String)

    func favorites() -> Results<FavoriteEntity>

    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool

    func isTagsEmpty(hymnIdentifier: HymnIdentifier)

    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification
}

class FavoritesStoreRealmImpl: FavoritesStore {

    private let analytics: AnalyticsLogger
    private let realm: Realm

    init(analytics: AnalyticsLogger = Resolver.resolve(), realm: Realm) {
        self.analytics = analytics
        self.realm = realm
    }

    func storeFavorite(_ entity: FavoriteEntity) {
        do {
            entity.tags = "favorited"
            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            analytics.logError(message: "error orccured when storing favorite", error: error, extraParameters: ["primaryKey": entity.primaryKey])
        }
    }

    func unstoreFavorite(_ entity: FavoriteEntity) {
        do {
            entity.tags = ""

            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            analytics.logError(message: "error orccured when storing favorite", error: error, extraParameters: ["primaryKey": entity.primaryKey])
        }
    }

//TODO: change name later
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
        realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags CONTAINS[c] 'favorited'"))
    }

// MARK: Realm Query Functions
    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool {
        guard let queriedObject = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier)) else {
            return false
        }
        if queriedObject.tags.contains("favorited") {
            return true
        } else {
            return false
        }
    }

    /**Function is used to call delete on the realm object if tags are all empty*/
    func isTagsEmpty(hymnIdentifier: HymnIdentifier) {
        guard let queriedObject = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier)) else {
            return
        }
        if queriedObject.tags.isEmpty {
            deleteFavorite(primaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier))
            return
        } else {
            return
        }
    }

    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification {
        return realm.observe { (_, _) in
            let favorite = self.isFavorite(hymnIdentifier: hymnIdentifier)
            action(favorite)
        }.toNotification()
    }
}

extension Resolver {
    public static func registerFavoritesStore() {
        register(FavoritesStore.self) {
            // https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file
            var url = Realm.Configuration.defaultConfiguration.fileURL
            url?.deleteLastPathComponent()
            url?.appendPathComponent("favorites.realm")
            // If the Realm db is unable to be created, that's an unrecoverable error, so crashing the app is appropriate.
            // swiftlint:disable:next force_try
            let realm = try! Realm(fileURL: url!)
            return FavoritesStoreRealmImpl(realm: realm) as FavoritesStore
        }.scope(application)
    }
}
