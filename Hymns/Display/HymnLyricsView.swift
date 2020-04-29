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
                return ActivityIndicator().eraseToAnyView()
            }

            return VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(lyrics, id: \.self) { verseViewModel in
                            Group {
                                VerseView(viewModel: verseViewModel)
                                Spacer().frame(height: 15)
                            }
                        }
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

        let classic40ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40ViewModel.lyrics = classic40ViewModel.convertToViewModels(verses: classic40_preview.lyrics)
        let classic40 = HymnLyricsView(viewModel: classic40ViewModel)

        let classic1151ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ViewModel.lyrics = classic1151ViewModel.convertToViewModels(verses: classic1151_preview.lyrics)
        let classic1151 = HymnLyricsView(viewModel: classic1151ViewModel)

        let classic1334ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334ViewModel.lyrics = classic1334ViewModel.convertToViewModels(verses: classic1334_preview.lyrics)
        let classic1334 = HymnLyricsView(viewModel: classic1334ViewModel)

        return Group {
            classic40
            classic1151
            classic1334
        }
    }
}
