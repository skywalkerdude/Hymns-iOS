import SwiftUI

struct ContentView: View {
    @State var selected = 0

    var body: some View {
        TabView(selection: $selected) {
            //systemName: basically means they are coming from SF Icons.
            SearchView().tabItem {
                Image(systemName: "magnifyingglass")
            }.tag(0)

            BrowseView().tabItem {
                Image(systemName: "book")
            }.tag(1)

            FavoritesView().tabItem {
                Image(systemName: "heart")
                }.tag(2)

            SettingsView().tabItem {
                Image(systemName: "gear")
            }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
