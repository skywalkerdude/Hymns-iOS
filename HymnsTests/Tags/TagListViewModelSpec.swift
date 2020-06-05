import Combine
import Quick
import Mockingbird
import Nimble
import RealmSwift
@testable import Hymns

class TagListViewModelSpec: QuickSpec {
    override func spec() {
        describe("using an in-memory realm") {
            var inMemoryRealm: Realm!
            var tagStore: TagStoreRealmImpl!
            var target: TagListViewModel!
            beforeEach {
                // Don't worry about force_try in tests.
                // swiftlint:disable:next force_try
                inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TagStoreRealmImplSpec"))
                tagStore = TagStoreRealmImpl(realm: inMemoryRealm)
                target = TagListViewModel(tagStore: tagStore)
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
                    tagStore.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ"))

                    tagStore
                        .storeTag(TagEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun", tag: "Christ"))

                    tagStore.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Cheery"))

                    tagStore.storeTag(TagEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table"))
                }
                describe("getting all tags without duplication of tag names to display on tag list") {
                    it("should contain only unique tag names") {
                        target.fetchUniqueTags()
                        expect(target.tags).to(haveCount(3))
                    }
                }
                describe("getting all songs that contain a certain tag for use on tag sub list view.") {
                    it("should contain only unique tag names") {
                        target.fetchTagsByTags("Christ")
                        expect(target.tags).to(haveCount(2))
                    }
                }
            }
        }
    }
}
