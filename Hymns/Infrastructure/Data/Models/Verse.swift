import Foundation

/**
 * Structure of a Verse object.
 */
struct Verse: Codable {
    let verseType: VerseType
    let verseContent: [String]
    let transliteration: [String]?
}
