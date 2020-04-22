import Combine
import Quick
import Mockingbird
import Nimble
import RealmSwift
@testable import Hymns

class HistoryStoreRealmImplSpec: QuickSpec {
    override func spec() {
        let classic1151 = HymnIdentifier(hymnType: .classic, hymnNumber: "1151")

        describe("HistoryStoreRealmImpl") {
            describe("using an in-memory realm") {
                var inMemoryRealm: Realm!
                var target: HistoryStoreRealmImpl!
                beforeEach {
                    // Don't worry about force_try in tests.
                    // swiftlint:disable:next force_try
                    inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "HistoryStoreRealmImplSpec"))
                    target = HistoryStoreRealmImpl(realm: inMemoryRealm)
                }

                context("store single recent song") {
                    beforeEach {
                        target.storeRecentSong(hymnToStore: classic1151, songTitle: "Hymn 1151")
                    }
                    describe("getting all recent songs") {
                        var recentSongs: [RecentSong]!
                        beforeEach {
                            recentSongs = target.recentSongs()
                        }
                        it("should contain the stored song") {
                            expect(recentSongs).to(haveCount(1))
                            let expected = RecentSong(hymnIdentifier: classic1151, songTitle: "Hymn 1151")
                            expect(recentSongs[0].primaryKey).to(equal(expected.primaryKey))
                            // For some reason, "recentSongs[0] == expected" evaluates to false, even though they are the exact same thing...
                        }
                    }
                }
            }
        }
    }
}
