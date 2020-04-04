import SwiftUI
import Resolver

public struct HymnLyricsView: View {
    
    @ObservedObject private var viewModel: HymnLyricsViewModel
    
    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        guard let lyrics = viewModel.lyrics else {
            return AnyView(Text("error!"))
        }
        
        guard !lyrics.isEmpty else {
            return AnyView(Text("loading..."))
        }

        return AnyView(Text(lyrics[0].verseContent[0]))
    }
}

struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnLyricsView(viewModel: Resolver.resolve())
    }
}
