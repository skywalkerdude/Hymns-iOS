import Resolver
import SwiftUI

struct VerseLineView: View {

    @ObservedObject var viewModel: VerseLineViewModel
    @Binding var transliterate: Bool

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(viewModel.verseNumber ?? "").font(viewModel.fontSize.font).frame(minWidth: 12)
            }
            VStack(alignment: .leading) {
                if transliterate {
                    viewModel.transliteration.map { transliteration in
                        Text(transliteration.trimmingCharacters(in: .whitespacesAndNewlines)).font(viewModel.fontSize.font)
                    }
                }
                Text(viewModel.verseText.trimmingCharacters(in: .whitespacesAndNewlines)).font(viewModel.fontSize.font)
            }.fixedSize(horizontal: false, vertical: true).padding(.bottom, 5).lineSpacing(5)
        }
    }
}

#if DEBUG
struct VerseLineView_Previews: PreviewProvider {
    static var previews: some View {

        var doNotTransliterate = false
        let doNotTransliterateBinding = Binding<Bool>(
            get: {doNotTransliterate}, set: {doNotTransliterate = $0}
        )
        let regularVerseViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"),
                                      VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown")]
        let regularVerse = VStack(alignment: .leading) {
            VerseLineView(viewModel: regularVerseViewModels[0], transliterate: doNotTransliterateBinding)
            VerseLineView(viewModel: regularVerseViewModels[1], transliterate: doNotTransliterateBinding)
        }

        let largeTextViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"),
                                      VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown")]
        largeTextViewModels[0].fontSize = .large
        largeTextViewModels[1].fontSize = .large
        let largeText = VStack(alignment: .leading) {
            VerseLineView(viewModel: largeTextViewModels[0], transliterate: doNotTransliterateBinding)
            VerseLineView(viewModel: largeTextViewModels[1], transliterate: doNotTransliterateBinding)
        }

        let extraLargeTextViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "Drink! A river pure and clear that's flowing from the throne"),
                                      VerseLineViewModel(verseText: "Eat! The tree of life with fruits abundant, richly grown")]
        extraLargeTextViewModels[0].fontSize = .xlarge
        extraLargeTextViewModels[1].fontSize = .xlarge
        let extraLargeText = VStack(alignment: .leading) {
            VerseLineView(viewModel: extraLargeTextViewModels[0], transliterate: doNotTransliterateBinding)
            VerseLineView(viewModel: extraLargeTextViewModels[1], transliterate: doNotTransliterateBinding)
        }

        var transliterate = true
        let transliterateBinding = Binding<Bool>(
            get: {transliterate}, set: {transliterate = $0}
        )
        let transliterationViewModels = [VerseLineViewModel(verseNumber: "1", verseText: "喝！从宝座流出",
                                                            transliteration: "Hē! Cóng bǎozuò liúchū"),
                                         VerseLineViewModel(verseText: "纯净生命河的水",
                                                            transliteration: "Chúnjìng shēngmìng hé de shuǐ")]
        let transliteration = VStack(alignment: .leading) {
            VerseLineView(viewModel: transliterationViewModels[0], transliterate: transliterateBinding)
            VerseLineView(viewModel: transliterationViewModels[1], transliterate: transliterateBinding)
        }

        return Group {
            regularVerse.previewLayout(.fixed(width: 425, height: 50)).previewDisplayName("regular verse")
            transliteration.previewLayout(.fixed(width: 425, height: 100)).previewDisplayName("verse with transliteration")
            largeText.previewLayout(.fixed(width: 425, height: 100)).previewDisplayName("large text")
            extraLargeText.previewLayout(.fixed(width: 425, height:175)).previewDisplayName("extra large text")
        }
    }
}
#endif

struct VerseView: View {

    let viewModel: VerseViewModel
    @Binding var transliterate: Bool

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.verseLines, id: \.self) { verseLine in
                VerseLineView(viewModel: verseLine, transliterate: self.$transliterate)
            }
        }
    }
}

#if DEBUG
struct VerseView_Previews: PreviewProvider {
    static var previews: some View {

        var noTransliteration = false
        let noTransliterationBinding = Binding<Bool>(
            get: {noTransliteration}, set: {noTransliteration = $0}
        )

        return VStack(alignment: .leading) {
            VerseView(viewModel: VerseViewModel(verseNumber: "1", verseLines: ["Drink! A river pure and clear that's flowing from the throne", "Eat! The tree of life with fruits abundant, richly grown", "Look! No need of lamp nor sun nor moon to keep it bright, for", "  Here this is no night!"]), transliterate: noTransliterationBinding)
            VerseView(viewModel: VerseViewModel(verseLines: ["Do come, oh, do come,", "Says Spirit and the Bride:", "Do come, oh, do come,", "Let him that heareth, cry.", "Do come, oh, do come,", "Let him who thirsts and will", "  Take freely the water of life!"]), transliterate: noTransliterationBinding)
        }
    }
}
#endif
