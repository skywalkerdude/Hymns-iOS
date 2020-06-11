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
                inMemoryRealm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "TagStoreMock"))
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
            describe("store a few tags") {
                beforeEach {
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ", tagColor: .blue))
                    target.storeTag(TagEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun", tag: "Bread and wine", tagColor: .yellow))
                    target.storeTag(TagEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table", tagColor: .blue))
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is", tagColor: .red))
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life", tagColor: .red))
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", tagColor: .blue))
                }
                describe("getting one hymn's tags") {
                    it("should contain a tags for that hymn") {
                        let resultsOfQuery = target.getTagsForHymn(hymnIdentifier: classic1151)
                        //https://stackoverflow.com/questions/46043902/opposite-of-swift-zip-split-tuple-into-two-arrays Splitting tuples into two arrays
                        let (tagName, tagColor) = resultsOfQuery.reduce(into: ([String](), [TagColor]())) {
                            $0.0.append($1.tagName)
                            $0.1.append($1.tagColor)
                        }
                        expect(tagName).to(equal(["Christ", "Peace", "Life", "Is"]))
                        expect(tagColor).to(equal([.blue, .blue, .red, .red]))
                    }
                }
                describe("deleting a tag") {
                    it("should delete the tag") {
                        let queryBeforeDelete = target.getSongsByTag("Table")
                        expect(queryBeforeDelete).to(haveCount(1))
                        target.deleteTag(primaryKey: TagEntity.createPrimaryKey(hymnIdentifier: cebuano123, tag: ""), tag: "Table")
                        let queryAfterDelete = target.getSongsByTag("Table")
                        expect(queryAfterDelete).to(haveCount(0))
                    }
                }
                describe("getting songs for a tag") {
                    beforeEach {
                        target.storeTag(TagEntity(hymnIdentifier: classic500, songTitle: "Hymn 500", tag: "Christ", tagColor: .blue))
                        target.storeTag(TagEntity(hymnIdentifier: classic1109, songTitle: "Hymn 1109", tag: "Christ", tagColor: .blue))
                        target.storeTag(TagEntity(hymnIdentifier: cebuano123, songTitle: "Cebuano 123", tag: "Christ", tagColor: .red))
                    }
                    it("should return the correct songs") {
                        let actual = target.getSongsByTag("Christ")
                        expect(actual).to(haveCount(4))
                        expect(actual[0].title).to(equal("Hymn 1151"))
                        expect(actual[1].title).to(equal("Cebuano 123"))
                        expect(actual[2].title).to(equal("Hymn 1109"))
                        expect(actual[3].title).to(equal("Hymn 500"))
                    }
                }
                describe("getting unique tags") {
                    it("should return all the unique tags") {
                        let failure = self.expectation(description: "Invalid.failure")
                        failure.isInverted = true
                        let finished = self.expectation(description: "Invalid.finished")
                        // finished should not be called because this is a self-updating publisher.
                        finished.isInverted = true
                        let value = self.expectation(description: "Invalid.receiveValue")

                        let cancellable = target.getUniqueTags()
                            .sink(receiveCompletion: { state in
                                switch state {
                                case .failure:
                                    failure.fulfill()
                                case .finished:
                                    finished.fulfill()
                                }
                                return
                            }, receiveValue: { tags in
                                value.fulfill()
                                expect(tags).to(equal(["Christ", "Peace", "Bread and wine", "Life", "Is", "Table"]))
                            })
                        self.wait(for: [failure, finished, value], timeout: testTimeout)
                        cancellable.cancel()
                    }
                }
            }
        }
    }
}
