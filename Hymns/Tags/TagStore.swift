import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol TagStore {
    func storeFavorite(_ entity: FavoriteEntity)
    func deleteFavorite(primaryKey: String)
    func storeTag(_ entity: TagEntity)
    func deleteTag(primaryKey: String, tags: String)
    func favorites() -> Results<FavoriteEntity>
    func isFavorite(hymnIdentifier: HymnIdentifier) -> Bool
    func observeFavoriteStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification
    func querySelectedTags(tagSelected: String?) -> Results<TagEntity>
    func queryTagsForHymn(hymnIdentifier: HymnIdentifier) -> Results<TagEntity>
}

class TagStoreRealmImpl: TagStore {

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

    func storeTag(_ entity: TagEntity) {
        do {
            try realm.write {
                realm.add(entity, update: .modified)
            }
        } catch {
            analytics.logError(message: "error orccured when storing favorite", error: error, extraParameters: ["primaryKey": entity.primaryKey])
        }
    }

    func deleteTag(primaryKey: String, tags: String) {
           let entityToDelete = realm.objects(TagEntity.self).filter(NSPredicate(format: "tags CONTAINS[c] %@ AND primaryKey CONTAINS[c] %@", tags, primaryKey))

               do {
                   try realm.write {
                       realm.delete(entityToDelete)
                   }
               } catch {
                   analytics.logError(message: "error orccured when deleting tag", error: error, extraParameters: ["primaryKey": primaryKey])
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

    /** Can be used either with a value to specificially query for one tag or without the optional to query all tags*/
    func querySelectedTags(tagSelected: String?) -> Results<TagEntity> {
        guard let specificTag = tagSelected else {
            return realm.objects(TagEntity.self)
        }
        return realm.objects(TagEntity.self).filter(NSPredicate(format: "tags == %@", specificTag))
    }

    func queryTagsForHymn(hymnIdentifier: HymnIdentifier) -> Results<TagEntity> {
        return realm.objects(TagEntity.self).filter(NSPredicate(format: "primaryKey CONTAINS[c] %@", ("\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]())")))
    }
}

extension Resolver {
    public static func registerTagStore() {
        register(TagStore.self) {
            // https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file
            var url = Realm.Configuration.defaultConfiguration.fileURL
            url?.deleteLastPathComponent()
            url?.appendPathComponent("tags.realm")
            // If the Realm db is unable to be created, that's an unrecoverable error, so crashing the app is appropriate.
            // swiftlint:disable:next force_try
            let realm = try! Realm(fileURL: url!)
            return TagStoreRealmImpl(realm: realm) as TagStore
        }.scope(application)
    }
}
