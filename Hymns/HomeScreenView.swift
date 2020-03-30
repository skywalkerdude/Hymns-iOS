import SwiftUI

struct HomeScreenView: View {
    @State var selected = 0
    
    var body: some View {
        TabView(selection: $selected) {
            //systemName: basically means they are coming from SF Icons.
            HomeView().tabItem {
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
        Group {
            //preview all tabs
            HomeScreenView(selected: 0)
            HomeScreenView(selected: 1)
            HomeScreenView(selected: 2)
            HomeScreenView(selected: 3)

            //previws localization
            HomeScreenView().environment(\.locale, .init(identifier: "de"))
            HomeScreenView().environment(\.locale, .init(identifier: "es"))
    }
}
}

//de - German localization
//en - English localization
//es - Spanish localization

//To change preview device
//ex) .previewDevice("iPhone SE")
