import GRDB
import Quick
import Nimble
@testable import Hymns

class HymnDataStoreGrdbImplSpec: QuickSpec {

    override func spec() {
        describe("using an in-memory database queue") {
            var inMemoryDBQueue: DatabaseQueue!
            var target: HymnDataStoreGrdbImpl!
            beforeEach {
                // https://github.com/groue/GRDB.swift/blob/master/README.md#database-queues
                inMemoryDBQueue = DatabaseQueue()
                target = HymnDataStoreGrdbImpl(databaseQueue: inMemoryDBQueue, initializeTables: true)
            }

            describe("the database") {
                it("should have been initialized successfully") {
                    expect(target.databaseInitializedProperly).to(beTrue())
                }
            }

            describe("save a few songs") {
                beforeEach {
                    target.saveHymn(HymnEntity(hymnIdentifier: classic1151))
                    target.saveHymn(HymnEntity(hymnIdentifier: newSong145))
                    target.saveHymn(HymnEntity(hymnIdentifier: cebuano123))
                }
                context("getting a stored song") {
                    it("should return the stored song") {
                        let completion = XCTestExpectation(description: "completion received")
                        let value = XCTestExpectation(description: "value received")
                        let publisher = target.getHymn(cebuano123)
                            .print(self.description)
                            .sink(receiveCompletion: { state in
                                completion.fulfill()
                                expect(state).to(equal(.finished))
                            }, receiveValue: { entity in
                                value.fulfill()
                                expect(entity).to(equal(HymnEntity(hymnIdentifier: cebuano123)))
                            })
                        self.wait(for: [completion, value], timeout: testTimeout)
                        publisher.cancel()
                    }
                }
                context("getting an unstored song") {
                    it("should return a nil result") {
                        let completion = XCTestExpectation(description: "completion received")
                        let value = XCTestExpectation(description: "value received")
                        let publisher = target.getHymn(children24)
                            .print(self.description)
                            .sink(receiveCompletion: { state in
                                completion.fulfill()
                                expect(state).to(equal(.finished))
                            }, receiveValue: { entity in
                                value.fulfill()
                                expect(entity).to(beNil())
                            })
                        self.wait(for: [completion, value], timeout: testTimeout)
                        publisher.cancel()
                    }
                }
                context("database tables dropped") {
                    beforeEach {
                        inMemoryDBQueue.inDatabase { database in
                            // Don't worry about force_try in tests.
                            // swiftlint:disable:next force_try
                            try! database.drop(table: "SONG_DATA")
                        }
                    }

                    it("should trigger a completion failure") {
                        let completion = XCTestExpectation(description: "completion received")
                        let value = XCTestExpectation(description: "value received")
                        value.isInverted = true
                        let publisher = target.getHymn(children24)
                            .print(self.description)
                            .sink(receiveCompletion: { state in
                                completion.fulfill()
                                expect(state).to(equal(.failure(.data(description: "SQLite error 1 with statement `SELECT * FROM SONG_DATA WHERE HYMN_TYPE = ? AND HYMN_NUMBER = ? AND QUERY_PARAMS = ?`: no such table: SONG_DATA"))))
                            }, receiveValue: { _ in
                                value.fulfill()
                            })
                        self.wait(for: [completion, value], timeout: testTimeout)
                        publisher.cancel()
                    }
                }
            }
        }
    }
}
