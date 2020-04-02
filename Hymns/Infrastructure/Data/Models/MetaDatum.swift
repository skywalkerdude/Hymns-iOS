import Foundation

/**
 * Represents a single point of meta data for a hymn. It consists of a name and data associated with that name.
 */
struct MetaDatum: Codable {
    let name: String
    let data: [Datum]
}
