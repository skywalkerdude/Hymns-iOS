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
                    it("should contain all of the stored hymns") {
                        let resultsOfQuery = target.querySelectedTags(tagSelected: nil)
                        expect(resultsOfQuery).to(haveCount(3))
                    }
                }
                describe("getting one hymn's tags after storing multiple tags for that hymn") {
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
                describe("deleting a tag") {
                    it("should delete the tag") {
                        let queryBeforeDelete = target.querySelectedTags(tagSelected: "Table")
                        expect(queryBeforeDelete).to(haveCount(1))
                        target.deleteTag(primaryKey: TagEntity.createPrimaryKey(hymnIdentifier: cebuano123, tag: ""), tag: "Table")
                        let queryAfterDelete = target.querySelectedTags(tagSelected: "Table")
                        expect(queryAfterDelete).to(haveCount(0))
                    }
                }
            }
        }
    }
}
