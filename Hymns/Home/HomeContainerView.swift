import SwiftUI
import Resolver

struct HomeContainerView: View {

    @State var selectedTab: HomeTab = .home

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: Resolver.resolve())
                    .tabItem {HomeTab.home.getImage(selectedTab == HomeTab.home)}
                    .accessibility(label: HomeTab.home.label)
                    .tag(HomeTab.home)
                    .hideNavigationBar()

                BrowseView()
                    .tabItem { HomeTab.browse.getImage(selectedTab == HomeTab.browse)}
                    .accessibility(label: HomeTab.browse.label)
                    .tag(HomeTab.browse)
                    .hideNavigationBar()

                FavoritesView()
                    .tabItem {HomeTab.favorites.getImage(selectedTab == HomeTab.favorites)}
                    .accessibility(label: HomeTab.favorites.label)
                    .tag(HomeTab.favorites)
                    .hideNavigationBar()

                SettingsView()
                    .tabItem {HomeTab.settings.getImage(selectedTab == HomeTab.settings)}
                    .accessibility(label: HomeTab.settings.label)
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
