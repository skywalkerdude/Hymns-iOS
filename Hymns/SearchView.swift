import SwiftUI

struct SearchView: View {
    var hymns = hymnTestData
    @State private var searchText: String = ""

    //Currently we have to use UIKIT to change the unselected tabicons from grey to black.
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                List {
                    ForEach(hymns.filter { self.searchText.isEmpty ? true : $0.contains(self.searchText)}, id: \.self) { hymn in
                        Text(hymn)
                    }
                }.navigationBarTitle(Text("Look up any hymn"))
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
