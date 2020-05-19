import Foundation
import GRDB

struct SearchResultEntity: Decodable {
    let hymnType: HymnType
    let hymnNumber: String
    let queryParams: [String: String]?
    let title: String
    let matchInfo: Data

    enum CodingKeys: String, CodingKey {
        case hymnType = "HYMN_TYPE"
        case hymnNumber = "HYMN_NUMBER"
        case queryParams = "QUERY_PARAMS"
        case title = "SONG_TITLE"
        case matchInfo = "matchinfo(SEARCH_VIRTUAL_SONG_DATA, 's')"
    }
}

extension SearchResultEntity {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hymnType = try container.decode(HymnType.self, forKey: .hymnType)
        hymnNumber = try container.decode(String.self, forKey: .hymnNumber)
        queryParams = try container.decode(String.self, forKey: .queryParams).deserializeFromQueryParamString
        title = try container.decode(String.self, forKey: .title)
        matchInfo = try container.decode(Data.self, forKey: .matchInfo)
    }
}

extension SearchResultEntity: FetchableRecord {
}
