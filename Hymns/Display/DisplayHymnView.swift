import SwiftUI
import Resolver

struct DisplayHymnView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: DisplayHymnViewModel

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left").accentColor(.primary)
                }).padding()
                Spacer()
                Text(viewModel.title)
                    .fontWeight(.bold)
                Spacer()
                viewModel.isFavorited.map { isFavorited in
                    Button(action: {
                        self.viewModel.toggleFavorited()
                    }, label: {
                        isFavorited ? Image(systemName: "heart.fill").accentColor(.accentColor) : Image(systemName: "heart").accentColor(.primary)
                    })
                }
            }
            HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel)
        }
        .hideNavigationBar()
        .onAppear {
            self.viewModel.fetchHymn()
        }
    }
}

#if DEBUG
struct DetailHymnScreen_Previews: PreviewProvider {

    static var previews: some View {

        let loading = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))

        let classic40ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40ViewModel.title = "Hymn 40"
        classic40ViewModel.isFavorited = true
        let classic40Lyrics = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        classic40Lyrics.lyrics
            = [VerseViewModel(verseNumber: "1", verseLines: classic40_preview.lyrics[0].verseContent),
               VerseViewModel(verseLines: classic40_preview.lyrics[1].verseContent),
               VerseViewModel(verseNumber: "2", verseLines: classic40_preview.lyrics[2].verseContent),
               VerseViewModel(verseNumber: "3", verseLines: classic40_preview.lyrics[3].verseContent),
               VerseViewModel(verseNumber: "4", verseLines: classic40_preview.lyrics[4].verseContent)
        ]
        classic40ViewModel.hymnLyricsViewModel = classic40Lyrics
        let classic40 = DisplayHymnView(viewModel: classic40ViewModel)

        let classic1151ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151ViewModel.title = "Hymn 1151"
        classic1151ViewModel.isFavorited = false
        let classic1151Lyrics = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        classic1151Lyrics.lyrics
            = [VerseViewModel(verseNumber: "1", verseLines: classic1151_preview.lyrics[0].verseContent),
               VerseViewModel(verseLines: classic1151_preview.lyrics[1].verseContent),
               VerseViewModel(verseNumber: "2", verseLines: classic1151_preview.lyrics[2].verseContent),
               VerseViewModel(verseNumber: "3", verseLines: classic1151_preview.lyrics[3].verseContent),
               VerseViewModel(verseNumber: "4", verseLines: classic1151_preview.lyrics[4].verseContent)
        ]
        classic1151ViewModel.hymnLyricsViewModel = classic1151Lyrics
        let classic1151 = DisplayHymnView(viewModel: classic1151ViewModel)

        let classic1334ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334ViewModel.title = "Hymn 1334"
        classic1334ViewModel.isFavorited = true
        let classic1334Lyrics = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334)
        classic1334Lyrics.lyrics
            = [VerseViewModel(verseNumber: "1", verseLines: classic1334_preview.lyrics[0].verseContent)
        ]
        classic1334ViewModel.hymnLyricsViewModel = classic1334Lyrics
        let classic1334 = DisplayHymnView(viewModel: classic1334ViewModel)
        return Group {
            loading.previewDisplayName("loading")
            classic40.previewDevice("classic 40")
            classic1151.previewDisplayName("classic 1151")
            classic1334.previewDisplayName("classic 1334")
        }
    }
}
#endif
