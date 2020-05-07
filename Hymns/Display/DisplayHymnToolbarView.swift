import SwiftUI

struct DisplayHymnToolbarView: View {
    @State var toolbarTab = "lyrics"
    @ObservedObject private var viewModel: DisplayHymnViewModel

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("LYRICS").foregroundColor(self.toolbarTab == "lyrics" ? .accentColor : .primary).onTapGesture {
                    self.toolbarTab = "lyrics"
                }
                viewModel.chordsUrl.map { _ in
                    HStack {
                        Spacer()
                        Text("CHORDS").foregroundColor(self.toolbarTab == "chords" ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = "chords"
                        }
                    }
                }
                viewModel.chordsUrl.map { _ in
                    HStack {
                        Spacer()
                        Text("GUITAR").foregroundColor(self.toolbarTab == "guitar" ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = "guitar"
                        }
                    }
                }
                viewModel.chordsUrl.map { _ in
                    HStack {
                        Spacer()
                        Text("PIANO").foregroundColor(self.toolbarTab == "piano" ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = "piano"
                        }
                    }
                }
                Spacer()
            }
            Divider().edgesIgnoringSafeArea(.horizontal)
            if self.toolbarTab == "lyrics" {
                HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel).padding(.horizontal)
            } else if self.toolbarTab == "chords" && self.viewModel.chordsUrl != nil {
                WebView(url: self.viewModel.chordsUrl!)
            } else if self.toolbarTab == "guitar" && self.viewModel.guitarUrl != nil {
                WebView(url: self.viewModel.guitarUrl!)
            } else if self.toolbarTab == "piano" && self.viewModel.pianoUrl != nil {
                WebView(url: self.viewModel.pianoUrl!)
            }
        }
    }
}

struct DisplayHymnToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayHymnToolbarView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40))
    }
}
