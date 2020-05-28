import Foundation
import GRDB

struct CategoryEntity: Decodable, Equatable {
    let category: String
    let subcategory: String
    let count: Int

    enum CodingKeys: String, CodingKey {
        case category = "SONG_META_DATA_CATEGORY"
        case subcategory = "SONG_META_DATA_SUBCATEGORY"
        case count = "COUNT(1)"
    }
}

extension CategoryEntity: FetchableRecord {
}
