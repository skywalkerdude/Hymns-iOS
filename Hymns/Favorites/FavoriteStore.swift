import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol FavoritesStore {
    func storeFavorite(_ entity: FavoriteEntity)

    func deleteFavorite(primaryKey: String)

    func favorites() -> Results<FavoriteEntity>

    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool

    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification
}

class FavoritesStoreRealmImpl: FavoritesStore {

    private let realm: Realm

    init(realm: Realm) {
        self.realm = realm
    }

    func storeFavorite(_ entity: FavoriteEntity) {
        do {
            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            Crashlytics.crashlytics().log("error orccured when storing favorite \(entity): \(error.localizedDescription)")
        }
    }

    func deleteFavorite(primaryKey: String) {
        guard let entityToDelete = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: primaryKey) else {
            Crashlytics.crashlytics().log("tried to delete a favorite that didn't exist: \(primaryKey)")
            return
        }

        do {
            try realm.write {
                realm.delete(entityToDelete)
            }
        } catch {
            Crashlytics.crashlytics().log("error orccured when deleting favorite \(primaryKey): \(error.localizedDescription)")
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
