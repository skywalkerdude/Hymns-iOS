import SwiftUI

public struct HymnLyricsView: View {

    @ObservedObject private var viewModel: HymnLyricsViewModel

    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        Group { () -> AnyView in
            guard let lyrics = viewModel.lyrics else {
                return Text("error!").eraseToAnyView()
            }

            guard !lyrics.isEmpty else {
                return Text("loading...").eraseToAnyView()
            }

        return AnyView(
            VStack(alignment: .leading) {
                ForEach(lyrics, id: \.self) { verseViewModel in
                    Group {
                        if verseViewModel.verse.verseType == VerseType(rawValue: "chorus") {
                            VerseView(verseLines: verseViewModel.verse.verseContent)
                        } else {
                            VerseView(verseNumber: verseViewModel.verseNumber ?? "", verseLines: verseViewModel.verse.verseContent)
                        }
                        Spacer().frame(height: 15)
                    }
                }
            }.eraseToAnyView()
        }.onAppear {
            self.viewModel.fetchLyrics()
        }
    }
}

struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {

        let classic1151 = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151, hymnsRepository: Resolver.resolve(), mainQueue: Resolver.resolve(name: "main"))
        classic1151.lyrics = classic1151.convertToViewModels(verses: classic1151_preview.lyrics)
        let classic1151View = HymnLyricsView(viewModel: classic1151)

        let classic1334 = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334, hymnsRepository: Resolver.resolve(), mainQueue: Resolver.resolve(name: "main"))
        classic1334.lyrics = classic1334.convertToViewModels(verses: classic1334_preview.lyrics)
        let classic1334View = HymnLyricsView(viewModel: classic1334)

        return Group {
            classic1151View
            classic1334View
        }
    }
}
