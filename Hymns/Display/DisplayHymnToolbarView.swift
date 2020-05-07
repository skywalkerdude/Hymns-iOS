import SwiftUI

struct DisplayHymnToolbarView: View {
    @State var toolbarTab = ToolbarTabs.lyrics
    @ObservedObject private var viewModel: DisplayHymnViewModel

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("LYRICS").foregroundColor(self.toolbarTab == ToolbarTabs.lyrics ? .accentColor : .primary).onTapGesture {
                    self.toolbarTab = ToolbarTabs.lyrics
                }
                viewModel.chordsUrl.map { _ in
                    HStack {
                        Spacer()
                        Text("CHORDS").foregroundColor(self.toolbarTab == ToolbarTabs.chords ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = ToolbarTabs.chords
                        }
                    }
                }
                viewModel.chordsUrl.map { _ in
                    HStack {
                        Spacer()
                        Text("GUITAR").foregroundColor(self.toolbarTab == ToolbarTabs.guitar ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = ToolbarTabs.guitar
                        }
                    }
                }
                viewModel.chordsUrl.map { _ in
                    HStack {
                        Spacer()
                        Text("PIANO").foregroundColor(self.toolbarTab == ToolbarTabs.piano ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = ToolbarTabs.piano
                        }
                    }
                }
                Spacer()
            }
            Divider().edgesIgnoringSafeArea(.horizontal)
            if self.toolbarTab == ToolbarTabs.lyrics {
                HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel).padding(.horizontal)
            } else if self.toolbarTab == ToolbarTabs.chords && self.viewModel.chordsUrl != nil {
                WebView(url: self.viewModel.chordsUrl!)
            } else if self.toolbarTab == ToolbarTabs.guitar && self.viewModel.guitarUrl != nil {
                WebView(url: self.viewModel.guitarUrl!)
            } else if self.toolbarTab == ToolbarTabs.piano && self.viewModel.pianoUrl != nil {
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
