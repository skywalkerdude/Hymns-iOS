import SwiftUI

struct VerseLineView: View {
    private let verseNumber: String?
    private let verseText: String

    init(verseNumber: String, verseText: String) {
        self.verseNumber = verseNumber
        self.verseText = verseText
    }

    init(verseText: String) {
        self.verseNumber = nil
        self.verseText = verseText
    }

    var body: some View {
        HStack {
            Text(verseNumber ?? "").frame(width: 10)
            Text(verseText)
        }
    }
}

struct VerseLineView_Previews: PreviewProvider {
    static var previews: some View {
        VerseLineView(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne")
    }
}

struct VerseView: View {
    private let verseNumber: String?
    private let verseLines: [String]

    init(verseNumber: String, verseLines: [String]) {
        self.verseNumber = verseNumber
        self.verseLines = verseLines
    }

    init(verseLines: [String]) {
        self.verseNumber = nil
        self.verseLines = verseLines
    }

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<verseLines.count) { index in
                if self.verseNumber != nil && index == 0 {
                    VerseLineView(verseNumber: self.verseNumber!, verseText: self.verseLines[index])
                } else {
                    VerseLineView(verseText: self.verseLines[index])
                }
            }
        }
    }
}

struct VerseView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            VerseView(verseNumber: "1", verseLines: ["Drink! A river pure and clear that's flowing from the throne", "Eat! The tree of life with fruits abundant, richly grown", "Look! No need of lamp nor sun nor moon to keep it bright, for", "  Here this is no night!"])
            VerseView(verseLines: ["Do come, oh, do come,", "Says Spirit and the Bride:", "Do come, oh, do come,", "Let him that heareth, cry.", "Do come, oh, do come,", "Let him who thirsts and will", "  Take freely the water of life!"])
        }
    }
}
