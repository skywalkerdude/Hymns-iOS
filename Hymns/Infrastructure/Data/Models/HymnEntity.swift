import Foundation
import GRDB

/**
 * Structure of a Hymn object returned from the databse.
 */
struct HymnEntity: Equatable {
    static let databaseTableName = "NAME"
    // Prefer Int64 for auto-incremented database ids
    let id: Int64?
    let hymnType: String
    let hymnNumber: String
    let queryParams: String
    let title: String?
    let lyricsJson: String?
    let category: String?
    let subcategory: String?
    let author: String?
    let composer: String?
    let key: String?
    let time: String?
    let meter: String?
    let scriptures: String?
    let hymnCode: String?
    let musicJson: String?
    let svgSheetJson: String?
    let pdfSheetJson: String?
    let languagesJson: String?
    let relevantJson: String?

    // https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case hymnType = "HYMN_TYPE"
        case hymnNumber = "HYMN_NUMBER"
        case queryParams = "QUERY_PARAMS"
        case title = "SONG_TITLE"
        case lyricsJson = "SONG_LYRICS"
        case category = "SONG_META_DATA_CATEGORY"
        case subcategory = "SONG_META_DATA_SUBCATEGORY"
        case author = "SONG_META_DATA_AUTHOR"
        case composer = "SONG_META_DATA_COMPOSER"
        case key = "SONG_META_DATA_KEY"
        case time = "SONG_META_DATA_TIME"
        case meter = "SONG_META_DATA_METER"
        case scriptures = "SONG_META_DATA_SCRIPTURES"
        case hymnCode = "SONG_META_DATA_HYMN_CODE"
        case musicJson = "SONG_META_DATA_MUSIC"
        case svgSheetJson = "SONG_META_DATA_SVG_SHEET_MUSIC"
        case pdfSheetJson = "SONG_META_DATA_PDF_SHEET_MUSIC"
        case languagesJson = "SONG_META_DATA_LANGUAGES"
        case relevantJson = "SONG_META_DATA_RELEVANT"
    }
}

extension HymnEntity: Codable, FetchableRecord, PersistableRecord, MutablePersistableRecord {
    // https://github.com/groue/GRDB.swift/blob/master/README.md#conflict-resolution
    static let persistenceConflictPolicy = PersistenceConflictPolicy(insert: .replace, update: .replace)

    // Define database columns from CodingKeys
    private enum Columns {
        static let id = Column(CodingKeys.id)
        static let hymnType = Column(CodingKeys.hymnType)
        static let hymnNumber = Column(CodingKeys.hymnNumber)
        static let queryParams = Column(CodingKeys.queryParams)
        static let title = Column(CodingKeys.title)
        static let lyricsJson = Column(CodingKeys.lyricsJson)
        static let category = Column(CodingKeys.category)
        static let subcategory = Column(CodingKeys.subcategory)
        static let author = Column(CodingKeys.author)
        static let composer = Column(CodingKeys.composer)
        static let key = Column(CodingKeys.key)
        static let time = Column(CodingKeys.time)
        static let meter = Column(CodingKeys.meter)
        static let scriptures = Column(CodingKeys.scriptures)
        static let hymnCode = Column(CodingKeys.hymnCode)
        static let musicJson = Column(CodingKeys.musicJson)
        static let svgSheetJson = Column(CodingKeys.svgSheetJson)
        static let pdfSheetJson = Column(CodingKeys.pdfSheetJson)
        static let languagesJson = Column(CodingKeys.languagesJson)
        static let relevantJson = Column(CodingKeys.relevantJson)
    }
}

extension HymnEntity {

    /**
     * A convenient initializer that uses a `HymnIdentifier` and allows the caller to  set as many or as few fields as they want.
     */
    init(hymnIdentifier: HymnIdentifier,
         id: Int64? = nil,
         title: String? = nil,
         lyricsJson: String? = nil,
         category: String? = nil,
         subcategory: String? = nil,
         author: String? = nil,
         composer: String? = nil,
         key: String? = nil,
         time: String? = nil,
         meter: String? = nil,
         scriptures: String? = nil,
         hymnCode: String? = nil,
         musicJson: String? = nil,
         svgSheetJson: String? = nil,
         pdfSheetJson: String? = nil,
         languagesJson: String? = nil,
         relevantJson: String? = nil) {
        self.id = id
        self.hymnType = hymnIdentifier.hymnType.abbreviatedValue
        self.hymnNumber = hymnIdentifier.hymnNumber
        self.queryParams = hymnIdentifier.queryParamString
        self.title = title
        self.lyricsJson = lyricsJson
        self.category = category
        self.subcategory = subcategory
        self.author = author
        self.composer = composer
        self.key = key
        self.time = time
        self.meter = meter
        self.scriptures = scriptures
        self.hymnCode = hymnCode
        self.musicJson = musicJson
        self.svgSheetJson = svgSheetJson
        self.pdfSheetJson = pdfSheetJson
        self.languagesJson = languagesJson
        self.relevantJson = relevantJson
    }
}
