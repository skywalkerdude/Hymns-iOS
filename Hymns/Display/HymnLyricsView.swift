import SwiftUI

public struct HymnLyricsView: View {

    @ObservedObject private var viewModel: HymnLyricsViewModel
    @State var posDeltaY: CGFloat = 0  // Scroll Y Position
    @State var posOriginY: CGFloat = 0 // Original Y Position

    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
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

                        //Important to put this async because we are modifying a state dynamically in the view https://swiftui-lab.com/state-changes/
                        //We are tracking the scrollY here especially for lyrics to then update the title based on our Y position
                         GeometryReader { innerGeo -> Text in
                            DispatchQueue.main.async {
                            self.posDeltaY = innerGeo.frame(in: .global).minY //although this modifies state during view update we are doing it in an async that is safe
                            }
                             return Text("")
                         }.onAppear { self.posOriginY = self.posDeltaY }
                        ForEach(lyrics, id: \.self) { verseViewModel in
                            Group {
                                VerseView(viewModel: verseViewModel)
                                Spacer().frame(height: 15)
                            }
                        }
                    }
                }
            }.maxSize(alignment: .leading).eraseToAnyView()
        }.onAppear {
            self.viewModel.fetchLyrics()
        }
    }
}
/*
#if DEBUG
struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {

        let loadingViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        let loading = HymnLyricsView(viewModel: loadingViewModel)

        let errorViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        errorViewModel.lyrics = nil
        let error = HymnLyricsView(viewModel: errorViewModel)

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
            loading.previewDisplayName("loading")
            error.previewDisplayName("error")
            classic40.previewDisplayName("classic40")
            classic1151.previewDisplayName("classic1151")
            classic1334.previewDisplayName("classic1334")
        }
    }
}
#endif
*/
