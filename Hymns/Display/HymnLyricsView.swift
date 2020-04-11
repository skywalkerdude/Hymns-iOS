import SwiftUI
import Resolver

public struct HymnLyricsView: View {

    @ObservedObject private var viewModel: HymnLyricsViewModel

    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        guard let lyrics = viewModel.lyrics else {
            return AnyView(Text("error!"))
        }

        guard !lyrics.isEmpty else {
            return AnyView(Text("loading..."))
        }
        var verseIndex: Int = 0

        func isVerse(verseType: VerseType) -> Int {
            if verseType != VerseType(rawValue: "chorus") {
                verseIndex += 1
                return verseIndex
            }
            return 0
        }
        return AnyView(
            VStack(alignment: .leading) {
                ForEach(lyrics, id: \.self) { verse in
                    Group {
                        if verse.verseType == VerseType(rawValue: "chorus") {
                            VerseView(verseLines: verse.verseContent)
                                .frame(width: 400, height: 150, alignment: .center)
                        } else {
                            VerseView(verseNumber: "\(isVerse(verseType: verse.verseType))", verseLines: verse.verseContent)
                        }
                        Spacer().frame(height: 15)
                    }
                }
                Spacer()
            }
        )
    }
}

struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {

        let classic1151 = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151, hymnsRepository: Resolver.resolve(), mainQueue: Resolver.resolve(name: "main"))
        classic1151.lyrics = classic1151_preview.lyrics
        let classic1151View = HymnLyricsView(viewModel: classic1151)

        let classic1334 = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334, hymnsRepository: Resolver.resolve(), mainQueue: Resolver.resolve(name: "main"))
        classic1334.lyrics = classic1334_preview.lyrics
        let classic1334View = HymnLyricsView(viewModel: classic1334)

        return Group {
            classic1151View
            classic1334View
        }
    }
}
