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
                    Image(systemName: "chevron.left").accentColor(Color.black)
                }).padding()
                Spacer()
                Text(viewModel.title)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {self.viewModel.toggleFavorited()
                }) {
                    self.viewModel.favoritedStatus ? Image(systemName: "heart.fill").accentColor(Color.blue) : Image(systemName: "heart").accentColor(Color.black)
                }
            }
            Spacer()
            HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel)
            Spacer()
        }
        .hideNavigationBar()
        .onAppear {
            self.viewModel.fetchHymn()
        }
    }
}

struct DetailHymnScreen_Previews: PreviewProvider {

    static var previews: some View {

        let classic1151View = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
        let classic1334View = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334))

        return Group {
            classic1151View
            classic1334View
        }
    }
}
