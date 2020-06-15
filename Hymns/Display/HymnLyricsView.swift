import SwiftUI

public struct HymnLyricsView: View {

    @ObservedObject private var viewModel: HymnLyricsViewModel
    @State var transliterate = false

    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
    }
    public var body: some View {
        Group { () -> AnyView in
            guard let lyrics = viewModel.lyrics else {
                return Text("Lyrics are not available for this song").maxSize().eraseToAnyView()
            }
            
            guard !lyrics.isEmpty else {
                return ActivityIndicator().maxSize().eraseToAnyView()
            }
            
            return
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 15) {
                        if viewModel.showTransliterationButton {
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.transliterate.toggle()
                                }, label: {
                                    self.transliterate ?
                                        Image(systemName: "a.square.fill").accentColor(.accentColor) :
                                        Image(systemName: "a.square").accentColor(.primary)
                                }).frame(width: 25, height: 25)
                            }
                        }
                        ForEach(lyrics, id: \.self) { verseViewModel in
                            VerseView(viewModel: verseViewModel, transliterate: self.$transliterate)
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).padding()
                }.maxSize(alignment: .leading).eraseToAnyView()
        }.onAppear {
            self.viewModel.fetchLyrics()
        }.background(Color(.systemBackground))
    }
}

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

        let chineseSupplement216ViewModel = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.chineseSupplement216)
        chineseSupplement216ViewModel.lyrics = chineseSupplement216ViewModel.convertToViewModels(verses: chineseSupplement216_preview.lyrics)
        chineseSupplement216ViewModel.showTransliterationButton = true
        let chineseSupplement216 = HymnLyricsView(viewModel: chineseSupplement216ViewModel)

        return Group {
            loading.previewDisplayName("loading")
            error.previewDisplayName("error")
            classic40.previewDisplayName("classic40")
            classic1151.previewDisplayName("classic1151")
            classic1334.previewDisplayName("classic1334")
            chineseSupplement216.previewDisplayName("chineseSupplement216")
        }
    }
}
#endif
