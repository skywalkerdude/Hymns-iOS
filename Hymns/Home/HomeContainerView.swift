import SwiftUI
import Resolver

struct HomeContainerView: View {

    @State var selectedTab: HomeTab = .home

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: Resolver.resolve())
                    .tabItem {HomeTab.home.getImage(selectedTab == HomeTab.home)}
                    .tag(HomeTab.home)
                    .hideNavigationBar()

                BrowseView()
                    .tabItem { HomeTab.browse.getImage(selectedTab == HomeTab.browse)}
                    .tag(HomeTab.browse)
                    .hideNavigationBar()

                FavoritesView()
                    .tabItem {HomeTab.favorites.getImage(selectedTab == HomeTab.favorites)}
                    .tag(HomeTab.favorites)
                    .hideNavigationBar()

                SettingsView()
                    .tabItem {HomeTab.settings.getImage(selectedTab == HomeTab.settings)}
                    .tag(HomeTab.settings)
                    .hideNavigationBar()
            }.onAppear {
                // Make the unselected tabs black insetad of grey.
                UITabBar.appearance().unselectedItemTintColor = .black
            }.edgesIgnoringSafeArea(.top)
        }
    }
}

struct HomeContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //preview all tabs
            HomeContainerView(selectedTab: .home)
            HomeContainerView(selectedTab: .browse)
            HomeContainerView(selectedTab: .favorites)
            HomeContainerView(selectedTab: .settings)
            //previws localization
            HomeContainerView().environment(\.locale, .init(identifier: "de"))
            HomeContainerView().environment(\.locale, .init(identifier: "es"))
        }
    }
}
