import Resolver
import SwiftUI

struct VerseLineView: View {

    @ObservedObject var viewModel: VerseLineViewModel
    @EnvironmentObject var storeLyricsForShare: StoreLyricsForShare

    var body: some View {
        HStack(alignment: .top) {
            Text(viewModel.verseNumber ?? "").font(viewModel.fontSize.font).frame(minWidth: viewModel.fontSize.minWidth)
            Text(viewModel.verseText).font(viewModel.fontSize.font).lineSpacing(5).padding(.bottom, 5)
        }.onAppear() {
            self.storeLyricsForShare.text += "\n" + self.viewModel.verseText
        }
    }
}

#if DEBUG
struct VerseLineView_Previews: PreviewProvider {
    static var previews: some View {

        let regularVerseViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"),
                                      VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown")]
        let regularVerse = VStack(alignment: .leading) {
            VerseLineView(viewModel: regularVerseViewModels[0])
            VerseLineView(viewModel: regularVerseViewModels[1])
        }

        let largeTextViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"),
                                      VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown")]
        largeTextViewModels[0].fontSize = .large
        largeTextViewModels[1].fontSize = .large
        let largeText = VStack(alignment: .leading) {
            VerseLineView(viewModel: largeTextViewModels[0])
            VerseLineView(viewModel: largeTextViewModels[1])
        }

        let extraLargeTextViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"),
                                      VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown")]
        extraLargeTextViewModels[0].fontSize = .xlarge
        extraLargeTextViewModels[1].fontSize = .xlarge
        let extraLargeText = VStack(alignment: .leading) {
            VerseLineView(viewModel: extraLargeTextViewModels[0])
            VerseLineView(viewModel: extraLargeTextViewModels[1])
        }

        let transliterationViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne",
                                                            transliteration: "h\\u0113 \\uff01 c\\u00f3ng b\\u01ceo zu\\u00f2 l\\u00edu ch\\u016b"),
                                         VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown",
                                                            transliteration: "ch\\u00fan j\\u00ecng sh\\u0113ng m\\u00ecng h\\u00e9 de sh\\u01d4i \\uff01")]
        let transliteration = VStack(alignment: .leading) {
            VerseLineView(viewModel: transliterationViewModels[0])
            VerseLineView(viewModel: transliterationViewModels[1])
        }

        return Group {
            regularVerse.previewLayout(.fixed(width: 425, height: 50)).previewDisplayName("regular verse")
            transliteration.previewLayout(.fixed(width: 425, height: 50)).previewDisplayName("verse with transliteration")
            largeText.previewLayout(.fixed(width: 425, height: 100)).previewDisplayName("large text")
            extraLargeText.previewLayout(.fixed(width: 425, height:175)).previewDisplayName("extra large text")
        }
    }
}
#endif

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

#if DEBUG
struct VerseView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            VerseView(viewModel: VerseViewModel(verseNumber: "1", verseLines: ["Drink! A river pure and clear that's flowing from the throne", "Eat! The tree of life with fruits abundant, richly grown", "Look! No need of lamp nor sun nor moon to keep it bright, for", "  Here this is no night!"]))
            VerseView(viewModel: VerseViewModel(verseLines: ["Do come, oh, do come,", "Says Spirit and the Bride:", "Do come, oh, do come,", "Let him that heareth, cry.", "Do come, oh, do come,", "Let him who thirsts and will", "  Take freely the water of life!"]))
        }
    }
}
#endif
