import Foundation

struct VerseLineViewModel: Hashable {
    let verseNumber: String?
    let verseText: String
    let transliteration: String?
}

extension VerseLineViewModel {
    init(verseText: String) {
        self.verseNumber = nil
        self.verseText = verseText
        self.transliteration = nil
    }

    init(verseNumber: String, verseText: String) {
        self.verseNumber = verseNumber
        self.verseText = verseText
        self.transliteration = nil
    }

    init(verseText: String, transliteration: String) {
        self.verseNumber = nil
        self.verseText = verseText
        self.transliteration = transliteration
    }
}

struct VerseViewModel: Hashable {
    let verseLines: [VerseLineViewModel]

    init(verseLines: [String]) {
        self.init(verseNumber: nil, verseLines: verseLines, transliteration: nil)
    }

    init(verseLines: [String], transliteration: [String]?) {
        self.init(verseNumber: nil, verseLines: verseLines, transliteration: transliteration)
    }

    init(verseNumber: String, verseLines: [String]) {
        self.init(verseNumber: verseNumber, verseLines: verseLines, transliteration: nil)
    }

    init(verseNumber: String?, verseLines: [String], transliteration: [String]?) {
        self.verseLines = verseLines.enumerated().map { (index, line) -> VerseLineViewModel in
            let transliteration = transliteration?[index]
            return VerseLineViewModel(verseNumber: index == 0 ? verseNumber : nil, verseText: line, transliteration: transliteration)
        }
    }
}
