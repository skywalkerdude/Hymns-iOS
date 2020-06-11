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
            context("store a few tags") {
                beforeEach {
                    target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ", tagColor: .blue))
                    target.storeTag(TagEntity(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun", tag: "Bread and wine", tagColor: .yellow))
                    target.storeTag(TagEntity(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table", tagColor: .blue))
                }
                describe("getting one hymn's tags after storing multiple tags for that hymn") {
                    beforeEach {
                        target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is", tagColor: .red))
                        target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life", tagColor: .red))
                        target.storeTag(TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", tagColor: .blue))
                    }
                    it("should contain a query number matching the number of tags for that hymn") {
                        let failure = self.expectation(description: "Invalid.failure")
                        failure.isInverted = true
                        let finished = self.expectation(description: "Invalid.finished")
                        // finished should not be called because this is a self-updating publisher.
                        finished.isInverted = true
                        let value = self.expectation(description: "Invalid.receiveValue")

                        let cancellable = target.getTagsForHymn(hymnIdentifier: classic1151)
                            .sink(receiveCompletion: { (completion: Subscribers.Completion<ErrorType>) -> Void in
                                switch completion {
                                case .failure:
                                    failure.fulfill()
                                case .finished:
                                    finished.fulfill()
                                }
                                return
                            }, receiveValue: { entities in
                                value.fulfill()
                                expect(entities).to(contain([TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ", tagColor: .blue), TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is", tagColor: .red), TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life", tagColor: .red), TagEntity(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", tagColor: .blue)]))
                            })
                        self.wait(for: [failure, finished, value], timeout: testTimeout)
                        cancellable.cancel()
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
                    it("should return the correctt songs") {
                        let actual = target.getSongsByTag("Christ")
                        expect(actual).to(haveCount(4))
                        expect(actual[0].title).to(equal("Hymn 1151"))
                        expect(actual[1].title).to(equal("Cebuano 123"))
                        expect(actual[2].title).to(equal("Hymn 1109"))
                        expect(actual[3].title).to(equal("Hymn 500"))
                    }
                }
            }
        }
    }
}
