import SwiftUI

struct VerseLineView: View {

    let viewModel: VerseLineViewModel

    var body: some View {
        HStack {
            Text(viewModel.verseNumber ?? "").frame(width: 10)
            Text(viewModel.verseText)
        }
    }
}

struct VerseLineView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(alignment: .leading) {
                VerseLineView(viewModel: VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"))
                VerseLineView(viewModel: VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown"))
            }.previewDisplayName("regular verse")
            VStack(alignment: .leading) {
                VerseLineView(viewModel: VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne", transliteration: "h\\u0113 \\uff01 c\\u00f3ng b\\u01ceo zu\\u00f2 l\\u00edu ch\\u016b"))
                VerseLineView(viewModel: VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown", transliteration: "ch\\u00fan j\\u00ecng sh\\u0113ng m\\u00ecng h\\u00e9 de sh\\u01d4i \\uff01"))
            }.previewDisplayName("verse with transliteration")
        }.previewLayout(.fixed(width: 450, height: 50))
    }
}

struct VerseView: View {
    let viewModel: VerseViewModel

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.verseLines, id: \.self) { verseLine in
                VerseLineView(viewModel: verseLine)
            }
        }
    }
}

struct VerseView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            VerseView(viewModel: VerseViewModel(verseNumber: "1", verseLines: ["Drink! A river pure and clear that's flowing from the throne", "Eat! The tree of life with fruits abundant, richly grown", "Look! No need of lamp nor sun nor moon to keep it bright, for", "  Here this is no night!"]))
            VerseView(viewModel: VerseViewModel(verseLines: ["Do come, oh, do come,", "Says Spirit and the Bride:", "Do come, oh, do come,", "Let him that heareth, cry.", "Do come, oh, do come,", "Let him who thirsts and will", "  Take freely the water of life!"]))
        }
    }
}
