import Foundation

/**
 * Structure of a Hymn object.
 */
struct Hymn: Codable {
    let title: String
    let metaData: [MetaDatum]
    let lyrics: [Verse]
}
