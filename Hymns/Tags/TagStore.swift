import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol TagStore {
    func storeTag(_ entity: TagEntity)
    func deleteTag(primaryKey: String, tag: String)
    func observeTagStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification
    func getSelectedTags(tagSelected: String?) -> Results<TagEntity>
    func getTagsForHymn(hymnIdentifier: HymnIdentifier) -> Results<TagEntity>
    func getUniqueTags() ->  [String]
}

class TagStoreRealmImpl: TagStore {

    private let analytics: AnalyticsLogger
    private let realm: Realm
    typealias Tag = String

    init(analytics: AnalyticsLogger = Resolver.resolve(), realm: Realm) {
        self.analytics = analytics
        self.realm = realm
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

    func deleteTag(primaryKey: String, tag: String) {
           let entityToDelete = realm.objects(TagEntity.self).filter(NSPredicate(format: "tag CONTAINS[c] %@ AND primaryKey CONTAINS[c] %@", tag, primaryKey))

               do {
                   try realm.write {
                       realm.delete(entityToDelete)
                   }
               } catch {
                   analytics.logError(message: "error orccured when deleting tag", error: error, extraParameters: ["primaryKey": primaryKey])
               }
           }

    func isTagged(hymnIdentifier: HymnIdentifier) -> Bool {
        return realm.object(ofType: TagEntity.self, forPrimaryKey: FavoriteEntity.createPrimaryKey(hymnIdentifier: hymnIdentifier)) != nil
    }

    func observeTagStatus(hymnIdentifier: HymnIdentifier, action: @escaping (Bool) -> Void) -> Notification {
        return realm.observe { (_, _) in
            let favorite = self.isTagged(hymnIdentifier: hymnIdentifier)
            action(favorite)
        }.toNotification()
    }

    /** Can be used either with a value to specificially query for one tag or without the optional to query all tags*/
    func getSelectedTags(tagSelected: String?) -> Results<TagEntity> {
        guard let specificTag = tagSelected else {
            return realm.objects(TagEntity.self)
        }
        return realm.objects(TagEntity.self).filter(NSPredicate(format: "tag == %@", specificTag))
    }

    func getTagsForHymn(hymnIdentifier: HymnIdentifier) -> Results<TagEntity> {
        return realm.objects(TagEntity.self).filter(NSPredicate(format: "primaryKey CONTAINS[c] %@", ("\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]())")))
    }

    func getUniqueTags() -> [String] {
        let result = realm.objects(TagEntity.self).distinct(by: ["tag"])
        var tags = [String]()
        tags = result.map { (tagEntity) -> Tag in
            return tagEntity.tag
        }
        return tags
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
