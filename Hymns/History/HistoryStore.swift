import FirebaseCrashlytics
import Foundation
import RealmSwift
import Resolver

protocol HistoryStore {
    func recentSongs(onChanged: @escaping ([RecentSong]) -> Void) -> Notification
    func storeRecentSong(hymnToStore hymnIdentifier: HymnIdentifier, songTitle: String)
}

class HistoryStoreRealmImpl: HistoryStore {

    /**
     * Once the number of entries hits this threshold, start replacing the entries.
     */
    let numberToStore = 50

    private let analytics: AnalyticsLogger
    private let realm: Realm

    init(analytics: AnalyticsLogger = Resolver.resolve(), realm: Realm) {
        self.analytics = analytics
        self.realm = realm
    }

    /**
     * Gets a list of `RecentSong`s. but if the list is greater than `numberToStore`, then it will delete the excess `RecentSong`s from the database.
     */
    func recentSongs(onChanged: @escaping ([RecentSong]) -> Void) -> Notification {
        let results: Results<RecentSongEntity> = realm.objects(RecentSongEntity.self).sorted(byKeyPath: "created", ascending: false)
        if results.count > numberToStore {
            let entitiesToDelete = Array(results).suffix(results.count - numberToStore)
            do {
                try realm.write {
                    realm.delete(entitiesToDelete)
                }
            } catch {
                var extraParameters = [String: String]()
                for (index, entity) in entitiesToDelete.enumerated() {
                    extraParameters["primary_key \(index)"] = entity.primaryKey
                }
                analytics.logError(message: "error occurred when deleting recent songs", error: error, extraParameters: extraParameters)
            }
        }

        return results.observe { change in
            switch change {
            case .update(let entities, _, _, _):
                // single fallthrough statement makes sense here
                // swiftlint:disable:next no_fallthrough_only
                fallthrough
            case .initial(let entities):
                let recentSongs: [RecentSong] = entities.map { (entity) -> RecentSong in
                    entity.recentSong
                }
                onChanged(recentSongs)
            case .error(let error):
                self.analytics.logError(message: "error orccurred while observing recent songs", error: error)
            }
        }.toNotification()
    }

    func storeRecentSong(hymnToStore hymnIdentifier: HymnIdentifier, songTitle: String) {
        do {
            try realm.write {
                realm.add(
                    RecentSongEntity(recentSong:
                        RecentSong(hymnIdentifier: hymnIdentifier, songTitle: songTitle),
                                     created: Date()),
                    update: .modified)
            }
        } catch {
            analytics.logError(message: "error orccured when storing recent song", error: error, extraParameters: ["hymnIdentifier": String(describing: hymnIdentifier), "title": songTitle])
        }
    }
}

extension Resolver {
    public static func registerHistoryStore() {
        register(HistoryStore.self) {
            // https://stackoverflow.com/questions/28465706/how-to-find-my-realm-file
            var url = Realm.Configuration.defaultConfiguration.fileURL
            url?.deleteLastPathComponent()
            url?.appendPathComponent("history.realm")
            // If the Realm db is unable to be created, that's an unrecoverable error, so crashing the app is appropriate.
            // swiftlint:disable:next force_try
            let realm = try! Realm(fileURL: url!)
            return HistoryStoreRealmImpl(realm: realm) as HistoryStore
        }.scope(application)
    }
}
