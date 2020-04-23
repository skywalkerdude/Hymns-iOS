import Foundation
import RealmSwift
import Resolver

protocol FavoritesStore {
    func storeFavorite(_ entity: FavoriteEntity)

    func deleteFavorite(primaryKey: String)

    func favorites() -> Results<FavoriteEntity>

    func observeFavoriteStatus(on primaryKey: String, action: @escaping (Bool) -> Void) -> NotificationToken
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
            // TODO log in firebase
        }
    }

    func deleteFavorite(primaryKey: String) {
        guard let entityToDelete = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: primaryKey) else {
            // TODO log in firebase
            return
        }

        do {
            try realm.write {
                realm.delete(entityToDelete)
            }
        } catch {
            // TODO log in firebase
        }
    }

    func favorites() -> Results<FavoriteEntity> {
        realm.objects(FavoriteEntity.self)
    }

    func observeFavoriteStatus(on primaryKey: String, action: @escaping (Bool) -> Void) -> NotificationToken {
        return realm.observe { (_, realm) in
            let favorite = realm.object(ofType: FavoriteEntity.self, forPrimaryKey: primaryKey)
            action(favorite != nil)
        }
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
