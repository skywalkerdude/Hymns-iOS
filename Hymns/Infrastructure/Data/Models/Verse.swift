import Foundation

/**
 * Structure of a Verse object.
 */
struct Verse: Codable, Equatable, Hashable {
    let verseType: VerseType
    let verseContent: [String]
    let transliteration: [String]?
}

extension Verse {
    // Allows us to use a customer initializer along with the default memberwise one
    // https://www.hackingwithswift.com/articles/106/10-quick-swift-tips
    init(verseType: VerseType, verseContent: [String]) {
        self.verseType = verseType
        self.verseContent = verseContent
        self.transliteration = nil
    }
}
