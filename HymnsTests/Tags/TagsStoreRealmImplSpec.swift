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
                    target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ", color: .blue))
                    target.storeTag(Tag(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun", tag: "Bread and wine", color: .yellow))
                    target.storeTag(Tag(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table", color: .blue))
                    target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is", color: .red))
                    target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life", color: .red))
                    target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", color: .blue))
                    target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", color: .yellow))
                }
                describe("getting one hymn's tags after storing multiple tags for that hymn") {
                    beforeEach {
                        target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is", color: .red))
                        target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life", color: .red))
                        target.storeTag(Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", color: .blue))
                    }
                    it("should return the tags for that hymn") {
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
                            }, receiveValue: { tags in
                                value.fulfill()
                                expect(tags).to(equal([Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", color: .blue),
                                                       Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Life", color: .red),
                                                       Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Is", color: .red),
                                                       Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Peace", color: .yellow),
                                                       Tag(hymnIdentifier: classic1151, songTitle: "Hymn 1151", tag: "Christ", color: .blue)]))
                            })
                        self.wait(for: [failure, finished, value], timeout: testTimeout)
                        cancellable.cancel()
                    }
                }
                describe("deleting a tag") {
                    it("should delete the tag") {
                        let queryBeforeDelete = target.getSongsByTag(UiTag(title: "Table", color: .blue))
                        expect(queryBeforeDelete).to(haveCount(1))
                        target.deleteTag(Tag(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table", color: .blue))
                        let queryAfterDelete = target.getSongsByTag(UiTag(title: "Table", color: .blue))
                        expect(queryAfterDelete).to(haveCount(0))
                    }
                    it("should be case sensitive") {
                        let queryBeforeDelete = target.getSongsByTag(UiTag(title: "Table", color: .blue))
                        expect(queryBeforeDelete).to(haveCount(1))
                        target.deleteTag(Tag(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "table", color: .blue))
                        let queryAfterDelete = target.getSongsByTag(UiTag(title: "Table", color: .blue))
                        expect(queryAfterDelete).to(haveCount(1))
                    }
                    it("not delete if the color doesn't match") {
                        let queryBeforeDelete = target.getSongsByTag(UiTag(title: "Table", color: .blue))
                        expect(queryBeforeDelete).to(haveCount(1))
                        target.deleteTag(Tag(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014", tag: "Table", color: .green))
                        let queryAfterDelete = target.getSongsByTag(UiTag(title: "Table", color: .blue))
                        expect(queryAfterDelete).to(haveCount(1))
                    }
                }
                describe("getting songs for a tag") {
                    beforeEach {
                        target.storeTag(Tag(hymnIdentifier: classic500, songTitle: "Hymn 500", tag: "Christ", color: .blue))
                        target.storeTag(Tag(hymnIdentifier: classic1109, songTitle: "Hymn 1109", tag: "Christ", color: .blue))
                        target.storeTag(Tag(hymnIdentifier: cebuano123, songTitle: "Cebuano 123", tag: "Christ", color: .red))
                    }
                    it("should return the correct songs") {
                        let actual = target.getSongsByTag(UiTag(title: "Christ", color: .blue))
                        expect(actual).to(haveCount(3))
                        expect(actual[0].title).to(equal("Hymn 1109"))
                        expect(actual[1].title).to(equal("Hymn 500"))
                        expect(actual[2].title).to(equal("Hymn 1151"))
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
                                expect(tags).to(equal([UiTag(title: "Peace", color: .yellow),
                                                       UiTag(title: "Peace", color: .blue),
                                                       UiTag(title: "Life", color: .red),
                                                       UiTag(title: "Table", color: .blue),
                                                       UiTag(title: "Christ", color: .blue),
                                                       UiTag(title: "Bread and wine", color: .yellow),
                                                       UiTag(title: "Is", color: .red)]))
                            })
                        self.wait(for: [failure, finished, value], timeout: testTimeout)
                        cancellable.cancel()
                    }
                }
            }
        }
    }
}
