import Combine
import Foundation
import Resolver
import SwiftUI

/**
    This class is specifically a way to actually store hymn lyrics for when they need to be shared with other people. The text is simply populated dynamically when the verse views appear and later depopulated when that hymn disappears.
*/
class StoreLyricsForShare: ObservableObject {
    var text = ""
}

class VerseLineViewModel: Hashable, ObservableObject {

    @Published var fontSize: FontSize

    let verseNumber: String?
    let verseText: String
    let transliteration: String?

    private var disposables = Set<AnyCancellable>()

    init(verseNumber: String?, verseText: String, transliteration: String?,
         userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.verseNumber = verseNumber
        self.verseText = verseText
        self.transliteration = transliteration
        self.fontSize = userDefaultsManager.fontSize
        userDefaultsManager
            .fontSizeSubject
            .sink { fontSize in
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.fontSize = fontSize
                }
        }.store(in: &disposables)
    }

    static func == (lhs: VerseLineViewModel, rhs: VerseLineViewModel) -> Bool {
        lhs.verseNumber == rhs.verseNumber && lhs.verseText == rhs.verseText && lhs.transliteration == rhs.transliteration
    }

    func hash(into hasher: inout Hasher) {
        if let verseNumber = verseNumber {
            hasher.combine(verseNumber)
        }
        hasher.combine(verseText)
        if let transliteration = transliteration {
            hasher.combine(transliteration)
        }
    }
}

extension VerseLineViewModel {
    convenience init(verseText: String) {
        self.init(verseNumber: nil, verseText: verseText, transliteration: nil)
    }

    convenience init(verseNumber: String, verseText: String) {
        self.init(verseNumber: verseNumber, verseText: verseText, transliteration: nil)
    }

    convenience init(verseText: String, transliteration: String) {
        self.init(verseNumber: nil, verseText: verseText, transliteration: transliteration)
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
