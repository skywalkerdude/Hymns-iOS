import SwiftUI
import Resolver

struct DisplayHymnView: View {

    var viewModel: DisplayHymnViewModel

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        NavigationLink(destination: HomeView(viewModel: Resolver.resolve())) {
                            Image(systemName: "xmark")
                        }
                        Spacer()
                        if self.viewModel.favorited == true {
                        }
                        //TODO: Favorited needs to actually do something when clicked other than just say "favorited"
                        Spacer()
                        Button(action: {self.viewModel.toggleFavorited()}) {
                            self.viewModel.favorited ? Image(systemName: "heart.fill") : Image(systemName: "heart")
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
            HymnLyricsView(viewModel: self.viewModel.hymnLyricsViewModel)
            Spacer() //This spacer is to keep the container at the top in "loading" cases
        }.navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
    }

    init(viewModel: DisplayHymnViewModel) {
        self.viewModel = viewModel
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
