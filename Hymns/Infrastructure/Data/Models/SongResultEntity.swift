import Foundation

struct SongResultEntity: Equatable {
    let hymnType: HymnType
    let hymnNumber: String
    let queryParams: [String: String]?
    let title: String
}
