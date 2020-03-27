import SwiftUI

struct HomeScreenView: View {
    @State var selected = 0

    //Currently we have to use UIKIT to change the unselected tabicons from grey to black.
    init() {
         UITabBar.appearance().unselectedItemTintColor = UIColor.black
     }
    
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
        HomeScreenView().environment(\.locale, .init(identifier: "es"))
    }
}

//de - German localization
//en - English localization
//es - Spanish localization
