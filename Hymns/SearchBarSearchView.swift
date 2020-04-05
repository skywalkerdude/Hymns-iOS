import SwiftUI

struct SearchBarSearchView: View {
    @State private var searchText: String = ""
    var allHymns: [DummyHymnView] = testData
    @Binding var isActive: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { self.isActive.toggle()}) {
                    Image(systemName: "xmark")}.buttonStyle(PlainButtonStyle())
                }.padding([.horizontal])
            SearchBar(text: $searchText)
            List {
                ForEach(self.allHymns.filter { self.searchText.isEmpty ? true : $0.songTitle.contains(self.searchText)}) { hymn in
                      NavigationLink(destination: DetailHymnScreen(hymn: hymn)) {
                        Text(hymn.songTitle)}
                }
            }.padding(.trailing, -32.0) //This clever guy hides nav arrows
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true) //hides the default nav bar to input the custom "x" instead
        }
}

struct SearchBarSearchView_Previews: PreviewProvider {
    @State static var isActive = false //neeed for preview to work
    
    static var previews: some View {
        SearchBarSearchView(isActive: $isActive)
    }
}
