import Foundation

struct VerseViewModel: Hashable {

    var verseNumber: String?
    let verse: Verse
    
    init(verseNumber: String, verse: Verse) {
        self.verseNumber = verseNumber
        self.verse = verse
    }
    init(verse: Verse) {
        self.verse = verse
    }
}
