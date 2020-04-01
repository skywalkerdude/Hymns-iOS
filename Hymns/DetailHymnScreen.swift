import SwiftUI

struct DetailHymnScreen: View {
    @State var favorited: Bool = false
    var hymn: DummyHymnView
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Image(systemName: "xmark")
                        Spacer()
                        if self.favorited == true {
                            Text("It's TRUE")
                        }
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
            }.frame(minHeight: 0, maxHeight: 60)  //end geometry
            Spacer()
            Text(self.hymn.songLyrics)
            Spacer()
        }//end outer VStack
    }
}

struct DetailHymnScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        DetailHymnScreen(hymn: testHymn)
    }
}
