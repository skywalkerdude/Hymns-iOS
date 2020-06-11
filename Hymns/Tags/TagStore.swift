import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol TagStore {
    func storeTag(_ entity: TagEntity)
    func deleteTag(primaryKey: String, tag: String)
    func getSongsByTag(_ tag: String) -> [SongResultViewModel]
    func getTagsForHymn(hymnIdentifier: HymnIdentifier) -> Results<TagEntity>
    func getUniqueTags() -> [String]
}

class TagStoreRealmImpl: TagStore {

    private let analytics: AnalyticsLogger
    private let realm: Realm

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

    /** Can be used either with a value to specificially query for one tag or without the optional to query all tags*/
    func getSongsByTag(_ tag: String) -> [SongResultViewModel] {
        let songResults: [SongResultViewModel] =
            realm.objects(TagEntity.self)
                .filter(NSPredicate(format: "tag == %@", tag))
                .map { entity -> SongResultViewModel in
                    let hymnIdentifier = HymnIdentifier(entity.hymnIdentifierEntity)
                    return SongResultViewModel(title: entity.songTitle, destinationView: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymnIdentifier)).eraseToAnyView())
        }
        return songResults
    }

    func getTagsForHymn(hymnIdentifier: HymnIdentifier) -> Results<TagEntity> {
        let filteredObject = realm.objects(TagEntity.self)
            .filter(NSPredicate(format: "primaryKey CONTAINS[c] %@", ("\(hymnIdentifier.hymnType):\(hymnIdentifier.hymnNumber):\(hymnIdentifier.queryParams ?? [String: String]())")))
        return filteredObject
    }

    func getUniqueTags() -> [String] {
        let result = realm.objects(TagEntity.self).distinct(by: ["tag"])
        return result.map { (tagEntity) -> String in
            tagEntity.tag
        }
    }
}


extension Resolver {
    public static func registerTagStore() {
        register(TagStore.self) {
            // https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file
            var url = Realm.Configuration.defaultConfiguration.fileURL
            url?.deleteLastPathComponent()
            url?.appendPathComponent("tags.realm")
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
            return TagStoreRealmImpl(realm: realm) as TagStore
        }.scope(application)
    }
}
