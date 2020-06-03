import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol FavoritesStore {
    func storeFavorite(_ entity: FavoriteEntity)

    func deleteFavoriteObject(primaryKey: String, tags: String)

    func getAllTags() -> Results<FavoriteEntity>

    func specificTag(tagSelected: String) -> Results<FavoriteEntity>

    func specificHymn(hymnIdentifier: HymnIdentifier) -> Results<FavoriteEntity>

    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool

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
            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            analytics.logError(message: "error orccured when storing favorite", error: error, extraParameters: ["primaryKey": entity.primaryKey])
        }
    }

    func deleteFavoriteObject(primaryKey: String, tags: String) {
        let entityToDelete = realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags CONTAINS[c] %@ AND primaryKey CONTAINS[c] %@", tags, primaryKey))

        do {
            try realm.write {
                realm.delete(entityToDelete)
            }
        } catch {
            analytics.logError(message: "error orccured when deleting favorite", error: error, extraParameters: ["primaryKey": primaryKey])
        }
    }

    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification {
        return realm.observe { (_, _) in
            let favorite = self.isFavorite(hymnIdentifier: hymnIdentifier)
            action(favorite)
        }.toNotification()
    }

    // MARK: Realm Query Functions
    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool {
        realm.object(ofType: FavoriteEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: "favorited")) != nil
    }

    func getAllTags() -> Results<FavoriteEntity> {
        return realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags != 'favorited'"))
    }

    func specificTag(tagSelected: String) -> Results<FavoriteEntity> {
        return realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags == %@", tagSelected))
    }

    func specificHymn(hymnIdentifier: HymnIdentifier) -> Results<FavoriteEntity> {
        let convertedKey = FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: "")
        return realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "primaryKey CONTAINS[c] %@ AND tags != %@", convertedKey, "favorited"))
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
