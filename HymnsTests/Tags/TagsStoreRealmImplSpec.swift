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
            context("store a few tags") {
                beforeEach {
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ"))

                    target
                        .storeTag(TagEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun", tag: "Bread and wine"))

                    target
                        .storeTag(TagEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table"))
                }
                describe("getting all tags") {
                    it("should contain the stored songs sorted by last-stored") {
                        let resultsOfQuery = target.querySelectedTags(tagSelected: nil)
                        expect(resultsOfQuery).to(haveCount(3))
                    }
                }
                describe("getting one hymns tags after storing multiple tags for that hymn") {
                    beforeEach {
                        target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is"))
                        target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life"))
                        target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace"))
                    }
                    it("should contain a query number matching the number of tags for that hymn") {
                        let resultsOfQuery = target.queryTagsForHymn(hymnIdentifier: classic1151)
                        expect(resultsOfQuery).to(haveCount(4))
                    }
                }
            }
        }
    }
}
