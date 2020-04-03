import Foundation

/**
 * Structure of a Verse object.
 */
struct Verse: Codable, Hashable {
    let verseType: VerseType
    let verseContent: [String]
    let transliteration: [String]?
}
