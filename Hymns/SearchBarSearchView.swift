import SwiftUI

struct SearchBarSearchView: View {
    @State private var searchText: String = ""
    var allHymns: [DummyHymnView] = testData

    var body: some View {
        VStack {
            SearchBar(text: $searchText)
        List {
            ForEach(self.allHymns.filter { self.searchText.isEmpty ? true : $0.songTitle.contains(self.searchText)}) { hymn in
                Text(hymn.songTitle)
            }
            }
        }.navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(false) //the only problem with this being true is you can't get back.... yikes
        }}

struct SearchBarSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarSearchView()
    }
}
