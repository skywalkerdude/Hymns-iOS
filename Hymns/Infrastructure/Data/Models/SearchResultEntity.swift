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
        let queryParamsString = try container.decode(String.self, forKey: .queryParams)
        if queryParamsString.isEmpty {
            queryParams = nil
        } else {
            queryParams = try container.decode(String.self, forKey: .queryParams)
                .replacingOccurrences(of: "?", with: "")
                .components(separatedBy: "&")
                .map({ component -> [String] in
                    component.components(separatedBy: "=")
                }).map({ components -> (key: String, value: String) in
                    if components.count < 2 {
                        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.queryParams], debugDescription: "unable to properly decode components: \(components)"))
                    }
                    return (key: components[0], value: components[1])
                }).reduce(into: [String: String](), { (result, arg1) in
                    let (key, value) = arg1
                    result[key] = value
                })
        }
        title = try container.decode(String.self, forKey: .title)
        matchInfo = try container.decode(Data.self, forKey: .matchInfo)
    }
}

extension SearchResultEntity: FetchableRecord {
}
