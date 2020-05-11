import SwiftUI

public struct HymnSelectedTagView<TabType: TabItem>: View {
    @Binding var currentTab: TabType
    @ObservedObject var viewModel: DisplayHymnViewModel
    
    public var body: some View {
        if self.currentTab.a11yLabel == Text("lyrics") {
            print("lyrics")
            return HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel).padding(.horizontal).eraseToAnyView()
        } else if self.currentTab.a11yLabel == Text("chords") {
            print("chords")
            return WebView(url: self.viewModel.chordsUrl!).eraseToAnyView()
        } else if self.currentTab.a11yLabel == Text("guitar")  {
            print("guitar")
            print(self.viewModel.guitarUrl!)
            return WebView(url: self.viewModel.guitarUrl!).eraseToAnyView()
        } else if self.currentTab.a11yLabel == Text("piano")  {
            print("piano")
            print(self.viewModel.pianoUrl!)
            return WebView(url: self.viewModel.pianoUrl!).eraseToAnyView()
        } else {
            return Text("Selection is undefined. This should never happen. Please file feedback with a screenshot: hymnalappfeedback@gmail.com").maxSize().eraseToAnyView()
        }
    }
}
//
//struct HymnSelectedTagView_Previews: PreviewProvider {
//    static var previews: some View {
//        HymnSelectedTagView()
//    }
//}
//
