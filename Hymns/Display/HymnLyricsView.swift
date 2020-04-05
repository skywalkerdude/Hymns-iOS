import SwiftUI
import Resolver

public struct HymnLyricsView: View {
    //@Binding var binded: Int
    @State var stanzaCount: Int = 1
    @ObservedObject private var viewModel: HymnLyricsViewModel
    
    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
    }
    
    /* This does not work yet. This has to be a function though because we can certainly not change state from within a ForEach that will only accept a view return. This pulls an error though "modifying state during view update, this will cause undefined behavior"*/
    func inputStanzaNumber() -> some View {
        self.stanzaCount += 1
        return Text("\(stanzaCount)")
      }
    
    public var body: some View {
        guard let lyrics = viewModel.lyrics else {
            return AnyView(Text("error!"))
        }
        
        guard !lyrics.isEmpty else {
            return AnyView(Text("loading..."))
        }
        
        return AnyView(
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(lyrics, id: \.self) { verse in
                        VStack { //needed to contain verticle spacer
                            Group {
                                HStack(alignment: .top) { //needed for verse numbers to be displayed to the left
                                    self.inputStanzaNumber() //FIX ME! Need to get verse number here based on verseType != to Chorus.
                                    VStack(alignment: .leading) {
                                        ForEach(verse.verseContent, id: \.self) { line in
                                            Text(line)
                                        }
                                    }
                                } //end of HSTACK containing all text and number
                            }
                            Spacer().frame(height: 30)
                        } //Needed because we need a container to hold the verticle spacer inside
                    } //end of for loop
                }
            }.padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 10)) //adds in side margins
        )
    }
}

struct HymnLyricsView_Previews: PreviewProvider {
    static var previews: some View {
        
        let classic1151 = HymnLyricsViewModel(hymnsRepository: Resolver.resolve())
        classic1151.lyrics = PreviewHymns.classic1151.lyrics
        let classic1151View = HymnLyricsView(viewModel: classic1151)
        
        let classic1334 = HymnLyricsViewModel(hymnsRepository: Resolver.resolve())
        classic1334.lyrics = PreviewHymns.classic1334.lyrics
        let classic1334View = HymnLyricsView(viewModel: classic1334)
        
        return Group {
            classic1151View
            classic1334View
        }
    }
}
