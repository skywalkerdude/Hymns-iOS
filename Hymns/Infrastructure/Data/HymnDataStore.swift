import Combine
import FirebaseCrashlytics
import Foundation
import GRDB
import GRDBCombine
import Resolver

/**
 * Service to contact the local Hymn database.
 */
protocol HymnDataStore {

    /**
     * Whether or not the database has been initialized properly. If this value is false, then the database is **NOT** save to use and clients should avoid using it.
     */
    var databaseInitializedProperly: Bool { get }

    func saveHymn(_ entity: HymnEntity)
    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType>
}

/**
 * Implementation of `HymnDataStore` that uses `GRDB`.
 */
class HymnDataStoreGrdbImpl: HymnDataStore {

    let tableName = "SONG_DATA"

    private(set) var databaseInitializedProperly = true

    private let databaseQueue: DatabaseQueue

    /**
     * Initializes the `HymnDataStoreGrdbImpl` object.
     *
     * - Parameter databaseQueue: `DatabaseQueue` object to use to make sql queries to
     * - Parameter initializeTables: Whether or not to create the necessary tables on startup
     */
    init(databaseQueue: DatabaseQueue, initializeTables: Bool = false) {
        self.databaseQueue = databaseQueue
        if initializeTables {
            databaseQueue.inDatabase { database in
                do {
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
                    try database.create(table: tableName, ifNotExists: true) { table in
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

                    // CREATE UNIQUE INDEX IF NOT EXISTS index_SONG_DATA_HYMN_TYPE_HYMN_NUMBER_QUERY_PARAMS ON SONG_DATA (HYMN_TYPE, HYMN_NUMBER, QUERY_PARAMS)
                    try database.create(index: "index_SONG_DATA_HYMN_TYPE_HYMN_NUMBER_QUERY_PARAMS",
                                        on: tableName,
                                        columns: [HymnEntity.CodingKeys.hymnType.rawValue, HymnEntity.CodingKeys.hymnNumber.rawValue, HymnEntity.CodingKeys.queryParams.rawValue],
                                        unique: true,
                                        ifNotExists: true)

                    // CREATE INDEX IF NOT EXISTS index_SONG_DATA_ID ON SONG_DATA (ID)
                    try database.create(index: "index_SONG_DATA_ID",
                                        on: tableName,
                                        columns: [HymnEntity.CodingKeys.id.rawValue],
                                        unique: false,
                                        ifNotExists: true)
                    try database.create(virtualTable: "SEARCH_VIRTUAL_SONG_DATA", ifNotExists: true, using: FTS4()) { table in
                        table.tokenizer = .porter
                        table.column(HymnEntity.CodingKeys.title.rawValue)
                        table.column(HymnEntity.CodingKeys.lyricsJson.rawValue)
                    }
                } catch {
                    databaseInitializedProperly = false
                    Crashlytics.crashlytics().log("unable to create tables for data store. Error: \(error.localizedDescription)")
                    Crashlytics.crashlytics().record(error: error)
                }
            }
        }
    }

    func saveHymn(_ entity: HymnEntity) {
        do {
            try self.databaseQueue.inDatabase { database in
                try entity.insert(database)
            }
        } catch {
            Crashlytics.crashlytics().log("unable to save entity \(entity). Error: \(error.localizedDescription)")
        }
    }

    func getHymn(_ hymnIdentifier: HymnIdentifier) -> AnyPublisher<HymnEntity?, ErrorType> {
        let hymnType = hymnIdentifier.hymnType.abbreviatedValue
        let hymnNumber = hymnIdentifier.hymnNumber
        let queryParams = hymnIdentifier.queryParamString

        return databaseQueue.readPublisher { database in
            try HymnEntity.fetchOne(database,
                                    sql: "SELECT * FROM SONG_DATA WHERE HYMN_TYPE = ? AND HYMN_NUMBER = ? AND QUERY_PARAMS = ?",
                                    arguments: [hymnType, hymnNumber, queryParams])
        }.mapError({error -> ErrorType in
            .data(description: error.localizedDescription)
        }).map({entity -> HymnEntity? in
            return entity
        }).eraseToAnyPublisher()
    }
}

extension Resolver {

    /**
     * Creates the hymn database and attempt to copy over the bundled database with fallbacks:
     *   1) Try to import bundled database. If that fails...
     *   2) Create a new database file and initialize it with empty tables. If that fails...
     *   3) Create an in-memory database and initialize it with empty tables. And if all fails...
     *   4) Indicate that the database isn't initialized correctly so that other classes will know to not use it
     *
     *   NOTE: These fallbacks need to be tested manually, as there is no way to mock/stub these file system interactions.
     */
    public static func registerHymnDataStore() {
        register(HymnDataStore.self) {
            let fileManager = FileManager.default
            guard let dbPath =
                try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("hymnaldb-v12.sqlite")
                    .path else {
                        Crashlytics.crashlytics().log("The desired path in Application Support is nil, so we are unable to create a databse file. Fall back to useing an in-memory db and initialize it with empty tables")
                        return HymnDataStoreGrdbImpl(databaseQueue: DatabaseQueue(), initializeTables: true) as HymnDataStore
            }

            /// Whether or not we need to create the tables for the database.
            var needToCreateTables: Bool = false
            outer: do {
                // Need to copy the bundled database into the Application Support directory on order for GRDB to access it
                // https://github.com/groue/GRDB.swift#how-do-i-open-a-database-stored-as-a-resource-of-my-application
                if !fileManager.fileExists(atPath: dbPath) {
                    guard let bundledDbPath = Bundle.main.path(forResource: "hymnaldb-v12", ofType: "sqlite") else {
                        Crashlytics.crashlytics().log("Path to the bundled database was not found, so just create an empty database instead and initialize it with empty tables")
                        needToCreateTables = true
                        break outer
                    }
                    try fileManager.copyItem(atPath: bundledDbPath, toPath: dbPath)
                    needToCreateTables = false
                }
            } catch {
                Crashlytics.crashlytics().log("Unable to copy bundled data to the Application Support directly, so just create an empty database there instead and initialize it with empty tables")
                needToCreateTables = true
            }

            let databaseQueue: DatabaseQueue
            do {
                databaseQueue = try DatabaseQueue(path: dbPath)
            } catch {
                Crashlytics.crashlytics().log("Unable to create database queue at the desired path, so create an in-memory one and initialize it with empty tables as a fallback")
                databaseQueue = DatabaseQueue()
                needToCreateTables = true
            }
            return HymnDataStoreGrdbImpl(databaseQueue: databaseQueue, initializeTables: needToCreateTables) as HymnDataStore
        }.scope(application)
    }
}
