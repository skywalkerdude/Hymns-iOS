import Foundation

/**
 * Structure of a Verse object.
 */
struct Verse: Codable, Identifiable {
    let id = UUID()
    let verseType: VerseType
    let verseContent: [String]
    let transliteration: [String]?
}
