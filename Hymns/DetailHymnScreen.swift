import SwiftUI
import Resolver

struct DetailHymnScreen: View {
    @State var favorited: Bool = false
    @ObservedObject private var viewModel: HymnLyricsViewModel // Pass through to Hymn Lyrics View

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        NavigationLink(destination: HomeView(viewModel: Resolver.resolve())) {
                            Image(systemName: "xmark")
                        }
                        Spacer()
                        if self.favorited == true {
                        }
                        //TODO: Favorited needs to actually do something when clicked other than just say "favorited"
                        Spacer()
                        Button(action: {self.favorited.toggle()}) {
                            self.favorited ? Image(systemName: "heart.fill") : Image(systemName: "heart")
                        }
                    }.frame(width: geometry.size.width/1.1)
                    HStack {
                        Spacer()
                        Text("Lyrics")
                        Spacer()
                        Text("Chords")
                        Spacer()
                        Text("Guitar")
                        Spacer()
                        Text("Piano")
                        Spacer()
                    }.frame(width: geometry.size.width/1)
                }.aspectRatio(contentMode: .fit).frame(height: 60).background(Color.white.shadow(radius: 2))
                Spacer()
                Spacer()
            }.frame(minHeight: 0, maxHeight: 60)
            HymnLyricsView(viewModel: self.viewModel)
        }
    }

    init(viewModel: HymnLyricsViewModel) {
        self.viewModel = viewModel
    }
}

struct DetailHymnScreen_Previews: PreviewProvider {

    static var previews: some View {
        //DetailHymnScreen()

        let classic1151 = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151, hymnsRepository: Resolver.resolve(), mainQueue: Resolver.resolve(name: "main"))
        classic1151.lyrics = classic1151_preview.lyrics
        let classic1151View = HymnLyricsView(viewModel: classic1151)

        let classic1334 = HymnLyricsViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334, hymnsRepository: Resolver.resolve(), mainQueue: Resolver.resolve(name: "main"))
        classic1334.lyrics = classic1334_preview.lyrics
        let classic1334View = HymnLyricsView(viewModel: classic1334)

        return Group {
            classic1151View
            classic1334View
        }
    }
}
