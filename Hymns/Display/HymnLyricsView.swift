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
        
        return AnyView(
            ForEach(lyrics) { verse in
                ForEach(verse.verseContent) { line in}
                Text(line)
            }
        )
    }
}




struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {
        HymnLyricsView(viewModel: HymnLyricsViewModel())
    }
}
