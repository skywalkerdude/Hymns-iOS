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
                    HStack {
                        Spacer()
                        Text("CHORDS").foregroundColor(self.toolbarTab == ToolbarTabs.chords ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = ToolbarTabs.chords
                        }
                    }
                    HStack {
                        Spacer()
                        Text("GUITAR").foregroundColor(self.toolbarTab == ToolbarTabs.guitar ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = ToolbarTabs.guitar
                        }
                    }
                    HStack {
                        Spacer()
                        Text("PIANO").foregroundColor(self.toolbarTab == ToolbarTabs.piano ? .accentColor : .primary).onTapGesture {
                            self.toolbarTab = ToolbarTabs.piano
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
            } else {
                VStack {
                    Spacer()
                    Text("No sheet music is available for this song")
                    Spacer()
                }
            }
        }
    }
}

struct DisplayHymnToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        let classic40ViewModel = DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)

        classic40ViewModel.chordsUrl = URL(string: "http://www.hymnal.net/en/hymn/h/40/f=gtpdf")
        classic40ViewModel.guitarUrl = URL(string: "http://www.hymnal.net/en/hymn/h/40/f=pdf")
        classic40ViewModel.pianoUrl = URL(string: "http://www.hymnal.net/en/hymn/h/40/f=ppdf")

        return Group {
        DisplayHymnToolbarView(viewModel: classic40ViewModel)
        DisplayHymnToolbarView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
        }
    }
}
