import SwiftUI

struct HomeSearchView: View {
    var allHymns: [DummyHymnView] = []
    var hymnTestData2 = hymnTestData
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List {
                ForEach(self.allHymns.filter { self.searchText.isEmpty ? true : $0.songTitle.contains(self.searchText)}) { hymn in
                    Text(hymn.songTitle)
                }.navigationBarTitle(Text("Look up any hymn"))
            }
        }
    }
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView(allHymns: testData)
    }
}
