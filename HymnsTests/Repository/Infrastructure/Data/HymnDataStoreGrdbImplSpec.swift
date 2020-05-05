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
                // CREATE TABLE SONG_DATA(
                //   ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                //   HYMN_TYPE TEXT NOT NULL,
                //   HYMN_NUMBER TEXT NOT NULL,
                //   QUERY_PARAMS TEXT NOT NULL,
                //   SONG_TITLE TEXT,
                //   SONG_LYRICS TEXT,
                //   SONG_META_DATA_CATEGORY TEXT,
                //   SONG_META_DATA_SUBCATEGORY TEXT,
                //   SONG_META_DATA_AUTHOR TEXT,
                //   SONG_META_DATA_COMPOSER TEXT,
                //   SONG_META_DATA_KEY TEXT,
                //   SONG_META_DATA_TIME TEXT,
                //   SONG_META_DATA_METER TEXT,
                //   SONG_META_DATA_SCRIPTURES TEXT,
                //   SONG_META_DATA_HYMN_CODE TEXT,
                //   SONG_META_DATA_MUSIC TEXT,
                //   SONG_META_DATA_SVG_SHEET_MUSIC TEXT,
                //   SONG_META_DATA_PDF_SHEET_MUSIC TEXT,
                //   SONG_META_DATA_LANGUAGES TEXT,
                //   SONG_META_DATA_RELEVANT TEXT
                // )
                inMemoryDBQueue.inDatabase { database in
                    // Don't worry about force_try in tests.
                    // swiftlint:disable:next force_try
                    try! database.create(table: "SONG_DATA") { table in
                        table.autoIncrementedPrimaryKey(HymnEntity.CodingKeys.id.rawValue)
                        table.column(HymnEntity.CodingKeys.hymnType.rawValue, .text).notNull()
                        table.column(HymnEntity.CodingKeys.hymnNumber.rawValue, .text).notNull()
                        table.column(HymnEntity.CodingKeys.queryParams.rawValue, .text).notNull()
                        table.column(HymnEntity.CodingKeys.title.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.lyricsJson.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.category.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.subcategory.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.author.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.composer.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.key.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.time.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.meter.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.scriptures.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.hymnCode.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.musicJson.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.svgSheetJson.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.pdfSheetJson.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.languagesJson.rawValue, .text)
                        table.column(HymnEntity.CodingKeys.relevantJson.rawValue, .text)
                    }
                }
                target = HymnDataStoreGrdbImpl(databaseQueue: inMemoryDBQueue)
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
                        completion.isInverted = true
                        let value = XCTestExpectation(description: "value received")
                        let publisher = target.getHymn(cebuano123)
                            .sink(receiveCompletion: { _ in
                                completion.fulfill()
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
                        completion.isInverted = true
                        let value = XCTestExpectation(description: "value received")
                        let publisher = target.getHymn(children24)
                            .sink(receiveCompletion: { _ in
                                completion.fulfill()
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
