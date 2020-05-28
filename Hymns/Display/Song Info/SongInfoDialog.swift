import SwiftUI

struct SongInfoDialog: View {

    @ObservedObject private var viewModel: SongInfoDialogViewModel

    init(viewModel: SongInfoDialogViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(viewModel.songInfo, id: \.self) { songInfo in
                SongInfoView(viewModel: songInfo)
            }
        }
        .padding()
        .cornerRadius(5)
        .background(Color(.secondarySystemBackground))
        .onAppear {
            self.viewModel.fetchSongInfo()
        }
    }
}

#if DEBUG
struct SongInfoDialog_Previews: PreviewProvider {
    static var previews: some View {

        let dialogViewModel = SongInfoDialogViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        dialogViewModel.songInfo = [SongInfoViewModel(label: "Category", values: ["Worship of the Father"]),
                                    SongInfoViewModel(label: "Subcategory", values: ["As the Source of Life"]),
                                    SongInfoViewModel(label: "Author", values: ["Will Jeng", "Titus Ting"])]
        let dialog = SongInfoDialog(viewModel: dialogViewModel)
        return Group {
            dialog.toPreviews()
        }
    }
}
#endif
