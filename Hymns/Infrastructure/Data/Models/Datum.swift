import Foundation

/**
 * Represents a single point of data for a hymn.
 */
struct Datum: Codable {
    let value: String
    let path: String
}
