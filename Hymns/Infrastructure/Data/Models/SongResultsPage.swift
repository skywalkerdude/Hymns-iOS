import Foundation

struct SongResultsPage: Decodable, Equatable {
    let results: [SongResult]
    let hasMorePages: Bool?
}

struct SongResult: Decodable, Equatable {
    let name: String
    let path: String
}
