import SwiftUI
import Resolver

struct DetailHymnScreen: View {
    @State var favorited: Bool = false

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
                            Text("Favorited")
                        }
                        //TODO: Favorited needs to actually do something when clicked other than just say "favorited"
                        Spacer()
                        Button(action: {self.favorited.toggle()})
                        {
                        Image(systemName: "heart")
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
            }.frame(minHeight: 0, maxHeight: 60)
        }
    }
}

struct DetailHymnScreen_Previews: PreviewProvider {

    static var previews: some View {
        DetailHymnScreen()
    }
}
