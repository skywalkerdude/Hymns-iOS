import Foundation

/**
 * Structure of a Verse object.
 */
struct Verse: Codable, Equatable {
    let verseType: VerseType
    let verseContent: [String]
    let transliteration: [String]?
}
