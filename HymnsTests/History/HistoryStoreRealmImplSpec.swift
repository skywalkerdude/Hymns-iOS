import Combine
import Quick
import Mockingbird
import Nimble
import RealmSwift
@testable import Hymns

class HistoryStoreRealmImplSpec: QuickSpec {
    override func spec() {
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

                afterEach {
                    // Don't worry about force_try in tests.
                    // swiftlint:disable:next force_try
                    try! inMemoryRealm.write {
                        inMemoryRealm.deleteAll()
                    }
                    inMemoryRealm.invalidate()
                }

                context("store a few recent songs") {
                    beforeEach {
                        target.storeRecentSong(hymnToStore: classic1151, songTitle: "Hymn 1151")
                        target.storeRecentSong(hymnToStore: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun")
                        target.storeRecentSong(hymnToStore: cebuano123, songTitle: "Naghigda sa lubong\\u2014")
                    }
                    describe("getting all recent songs") {
                        it("should contain the stored songs sorted by last-stored") {
                            let callbackExpectation = XCTestExpectation(description: "callback called")
                            let notification = target.recentSongs { recentSongs in
                                expect(recentSongs).to(haveCount(3))
                                expect(recentSongs[0]).to(equal(RecentSong(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014")))
                                expect(recentSongs[1]).to(equal(RecentSong(hymnIdentifier: newSong145, songTitle: "Hymn: Jesus shall reign where\\u2019er the sun")))
                                expect(recentSongs[2]).to(equal(RecentSong(hymnIdentifier: classic1151, songTitle: "Hymn 1151")))
                                callbackExpectation.fulfill()
                            }
                            self.wait(for: [callbackExpectation], timeout: testTimeout)
                            notification.invalidate()
                        }
                    }
                }
                let numberToStore = 100
                context("store \(numberToStore) recent songs") {
                    beforeEach {
                        for num in 1...numberToStore {
                            target.storeRecentSong(hymnToStore: HymnIdentifier(hymnType: .classic, hymnNumber: "\(num)"), songTitle: "song \(num)")
                        }
                    }
                    describe("getting all recent songs") {
                        it("should only contain the 50 last accessed songs") {
                            let callbackExpectation = XCTestExpectation(description: "callback called")
                            let notification = target.recentSongs { recentSongs in
                                expect(recentSongs).to(haveCount(50))
                                for (index, recentSong) in recentSongs.enumerated() {
                                    expect(recentSong).to(equal(RecentSong(hymnIdentifier: HymnIdentifier(hymnType: .classic, hymnNumber: "\(numberToStore - index)"), songTitle: "song \(numberToStore - index)")))
                                }
                                callbackExpectation.fulfill()
                            }
                            self.wait(for: [callbackExpectation], timeout: testTimeout)
                            notification.invalidate()
                        }
                    }
                }
            }
        }
    }
}
