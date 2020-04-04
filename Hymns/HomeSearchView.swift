import SwiftUI
import Resolver

struct HomeSearchView: View {
    @State var searchText: String = ""
    var allHymns: [DummyHymnView] = testData
    
    var body: some View {
        VStack {
            NavigateToSearch(searchText: searchText) //passes necessary param to extracted subview
            
            //This list does two things. It filters all the Hymns based on search function and it also provides the linking to their respective detailed views.
            List {
                ForEach(self.allHymns.filter { self.searchText.isEmpty ? true : $0.songTitle.contains(self.searchText)}) { hymn in
                    NavigationLink(destination: HymnLyricsView(viewModel: Resolver.resolve())) {
                        Text(hymn.songTitle)}
                }.navigationBarTitle(Text("Look up any hymn"))
            }.padding(.trailing, -32.0)
        }
    }
}

struct HomeSearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchView()
    }
}

struct NavigateToSearch: View {
    @State var isActive: Bool = false
    @State var searchText: String
    
    var body: some View {
        NavigationLink(destination: SearchBarSearchView(isActive: $isActive),
                       isActive: $isActive) {
                        Button(action: {
                            self.isActive.toggle()
                        }) {
                            SearchBar(text: $searchText).disabled(true)}}
    }
}
