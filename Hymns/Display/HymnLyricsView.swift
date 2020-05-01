import SwiftUI

public struct HymnLyricsView: View {

    @ObservedObject private var viewModel: HymnLyricsViewModel
    @Binding var posDeltaY: CGFloat  //Watch in DisplayHymnView
    @Binding var posOriginY: CGFloat

    init(viewModel: HymnLyricsViewModel, posDeltaY: Binding<CGFloat>, posOriginY: Binding<CGFloat>) {
        self.viewModel = viewModel
        self._posDeltaY = posDeltaY
        self._posOriginY = posOriginY
    }

    public var body: some View {
        Group { () -> AnyView in
            guard let lyrics = viewModel.lyrics else {
                return Text("error!").maxSize().eraseToAnyView()
            }

            guard !lyrics.isEmpty else {
                return ActivityIndicator().maxSize().eraseToAnyView()
            }

            return VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        //INNER GEO
                        GeometryReader { innerGeo -> Text in
                            self.posDeltaY = innerGeo.frame(in: .global).minY //although this modifies state during view update that way we are using it appears safe and is done in several tutorials online.
                            return Text("")
                        }.onAppear { self.posOriginY = self.posDeltaY
                        }
                        ForEach(lyrics, id: \.self) { verseViewModel in
                            Group {
                                VerseView(viewModel: verseViewModel)
                                Spacer().frame(height: 15)
                            }
                        }
                    }
                }
            }.maxSize(alignment: .leading).eraseToAnyView() //VSTACK
        }.onAppear {
            self.viewModel.fetchLyrics()
        }
    }
}

#if DEBUG
struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {

        let loadingViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        let loading = HymnLyricsView(viewModel: loadingViewModel, posDeltaY: .constant(0), posOriginY: .constant(0))

        let errorViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        errorViewModel.lyrics = nil
        let error = HymnLyricsView(viewModel: errorViewModel, posDeltaY: .constant(0), posOriginY: .constant(0))

        let classic40ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40ViewModel.lyrics = classic40ViewModel.convertToViewModels(verses: classic40_preview.lyrics)
        let classic40 = HymnLyricsView(viewModel: classic40ViewModel, posDeltaY: .constant(0), posOriginY: .constant(0))

        let classic1151ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ViewModel.lyrics = classic1151ViewModel.convertToViewModels(verses: classic1151_preview.lyrics)
        let classic1151 = HymnLyricsView(viewModel: classic1151ViewModel, posDeltaY: .constant(0), posOriginY: .constant(0))

        let classic1334ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334ViewModel.lyrics = classic1334ViewModel.convertToViewModels(verses: classic1334_preview.lyrics)
        let classic1334 = HymnLyricsView(viewModel: classic1334ViewModel, posDeltaY: .constant(0), posOriginY: .constant(0))

        return Group {
            loading.previewDisplayName("loading")
            error.previewDisplayName("error")
            classic40.previewDisplayName("classic40")
            classic1151.previewDisplayName("classic1151")
            classic1334.previewDisplayName("classic1334")
        }
    }
}
#endif
