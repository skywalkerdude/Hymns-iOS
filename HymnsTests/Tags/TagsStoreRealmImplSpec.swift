import Combine
import Quick
import Mockingbird
import Nimble
import RealmSwift
@testable import Hymns

class TagStoreRealmImplSpec: QuickSpec {
    override func spec() {
        describe("using an in-memory realm") {
            var inMemoryRealm: Realm!
            var target: TagStoreRealmImpl!
            beforeEach {
                // Don't worry about force_try in tests.
                // swiftlint:disable:next force_try
                inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TagStoreRealmImplSpec"))
                target = TagStoreRealmImpl(realm: inMemoryRealm)
            }
            afterEach {
                // Don't worry about force_try in tests.
                // swiftlint:disable:next force_try
                try! inMemoryRealm.write {
                    inMemoryRealm.deleteAll()
                }
                inMemoryRealm.invalidate()
            }

            context("store a few favorites") {
                beforeEach {
                    target.storeFavorite(FavoriteEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151"))

                    target
                        .storeFavorite(FavoriteEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun"))

                    target
                        .storeFavorite(FavoriteEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014"))
                }
                describe("get the list of all favorites") {
                    it("should be 0 when we query tagEntity") {

                        let queryAllTags = target.querySelectedTags(tagSelected: nil)
                        expect(queryAllTags).to(haveCount(0))


                    }
                    it("should be 3 when we query FavoriteEntity") {

                        let queryAllFavorites = inMemoryRealm.objects(FavoriteEntity.self)
                        expect(queryAllFavorites).to(haveCount(3))
                    }

                }
            }
            context("store a few tags") {
                beforeEach {
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ"))

                    target
                        .storeTag(TagEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun", tag: "Bread and wine"))

                    target
                        .storeTag(TagEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table"))
                }
                describe("getting all recent songs") {
                    it("should contain the stored songs sorted by last-stored") {

                        let resultsOfQuery = target.querySelectedTags(tagSelected: nil)
                        expect(resultsOfQuery).to(haveCount(3))
                    }
                }
            }
        }
    }
}
