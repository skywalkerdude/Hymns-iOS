import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol FavoritesStore {
    func storeFavorite(_ entity: FavoriteEntity)

    func deleteFavoriteObject(primaryKey: String, tags: String)

    func favorites() -> Results<FavoriteEntity>

    func tags() -> Results<FavoriteEntity>

    func specificTag(_ tagSelected: String) -> Results<FavoriteEntity>

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
        print("bbug store called")
        do {
            try realm.write {
                realm.add(entity, update: .all)
            }
        } catch {
            analytics.logError(message: "error orccured when storing favorite", error: error, extraParameters: ["primaryKey": entity.primaryKey])
        }
    }

    func deleteFavoriteObject(primaryKey: String, tags: String) {
        // Query using an NSPredicate
        let predicate = NSPredicate(format: "tags CONTAINS[c] %@ AND primaryKey CONTAINS[c] %@", tags, primaryKey)
        let entityToDelete = realm.objects(FavoriteEntity.self).filter(predicate)

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

    func tags() -> Results<FavoriteEntity> {
        print("bbug tags retrieve")
        return realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags != 'favorited'"))
    }

    func specificTag(_ tagSelected: String) -> Results<FavoriteEntity> {
        print("bbug tags retrieve")
        return realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags == %@", tagSelected))
    }

//    func tagsFirst() -> Results<FavoriteEntity> {
//
//        print("bbug tags retrieve")
//        return realm.objects(FavoriteEntity.self).filter(NSPredicate(format: "tags CONTAINS[c] 'Christ'"))
//    }

// MARK: Realm Query Functions
      func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool {
            //let convertedKey = FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: "favorited")
        return realm.object(ofType: FavoriteEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: "favorited")) != nil
        }

    /**Function is used to call delete on the realm object if tags are all empty*/
    func isTagsEmpty(hymnIdentifier: HymnIdentifier) {
       let queriedObject = realm.objects(FavoriteEntity.self).filter("tags = 'favorited' AND primaryKey BEGINSWITH '\(hymnIdentifier)'")

        if queriedObject.isEmpty {
            deleteFavoriteObject(primaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier, tags: ""), tags: "")
            return
        } else {
            return
        }
    }

//    func isTagsEmpty(hymnIdentifier: HymnIdentifier) {
//        guard let queriedObject = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier)) else {
//            return
//        }
//        if queriedObject.tags.isEmpty {
//            deleteFavoriteObject(primaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier))
//            return
//        } else {
//            return
//        }
//    }

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
