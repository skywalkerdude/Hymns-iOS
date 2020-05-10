import Combine
import FirebaseCrashlytics
import Foundation
import GRDB
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

    private(set) var databaseInitializedProperly = false

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
                    try database.create(table: tableName) { table in
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
                                        unique: true)

                    // CREATE INDEX IF NOT EXISTS index_SONG_DATA_ID ON SONG_DATA (ID)
                    try database.create(index: "index_SONG_DATA_ID",
                                        on: tableName,
                                        columns: [HymnEntity.CodingKeys.id.rawValue],
                                        unique: false)
                    try database.create(virtualTable: "SEARCH_VIRTUAL_SONG_DATA", using: FTS4()) { table in
                        table.tokenizer = .porter
                        table.column(HymnEntity.CodingKeys.title.rawValue)
                        table.column(HymnEntity.CodingKeys.lyricsJson.rawValue)
                    }
                    databaseInitializedProperly = true
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

        let publisher = CurrentValueSubject<HymnEntity?, ErrorType>(nil)
        do {
            let hymnEntity = try self.databaseQueue.inDatabase { database -> HymnEntity? in
                return try HymnEntity.fetchOne(database,
                                               sql: "SELECT * FROM SONG_DATA WHERE HYMN_TYPE = ? AND HYMN_NUMBER = ? AND QUERY_PARAMS = ?",
                                               arguments: [hymnType, hymnNumber, queryParams])
            }
            publisher.send(hymnEntity)
        } catch {
            publisher.send(completion: .failure(.data(description: error.localizedDescription)))
        }
        return publisher.eraseToAnyPublisher()
    }
}

extension Resolver {
    public static func registerHymnDataStore() {
        // TODO add Firebase Analytics to find out how often these database fallbacks are needed
        register(HymnDataStore.self) {

            // Need to copy the bundled database into the Application Support directory on order for GRDB to access it
            // https://github.com/groue/GRDB.swift#how-do-i-open-a-database-stored-as-a-resource-of-my-application
            let fileManager = FileManager.default
            guard let dbPath =
                try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("hymnaldb-v12.sqlite")
                    .path else {
                        // The path to the database that we want to create is nil, so just create an in-memory one
                        // and initialize it with empty tables as a fallback.
                        return HymnDataStoreGrdbImpl(databaseQueue: DatabaseQueue(), initializeTables: true) as HymnDataStore
            }

            /// Whether or not we need to create the tables for the database.
            var needToCreateTables: Bool = false
            outer: do {
                if !fileManager.fileExists(atPath: dbPath) {
                    guard let bundledDbPath = Bundle.main.path(forResource: "hymnaldb-v12", ofType: "sqlite") else {
                        // Path to the bundled database was not found, so we need to initialize empty tables upon
                        // database creation.
                        needToCreateTables = true
                        break outer
                    }
                    try fileManager.copyItem(atPath: bundledDbPath, toPath: dbPath)
                    needToCreateTables = false
                }
            } catch {
                // Unable to copy bundled data to over, so assume we have an empty database file that we need to initialize
                // with empty tables.
                needToCreateTables = true
            }

            let databaseQueue: DatabaseQueue
            do {
                databaseQueue = try DatabaseQueue(path: dbPath)
            } catch {
                // Unable to create database queue at the desired path, so create an in-memory one and initialize it with
                // empty tables as a fallback.
                databaseQueue = DatabaseQueue()
                needToCreateTables = true
            }
            return HymnDataStoreGrdbImpl(databaseQueue: databaseQueue, initializeTables: needToCreateTables) as HymnDataStore
        }.scope(application)
    }
}
