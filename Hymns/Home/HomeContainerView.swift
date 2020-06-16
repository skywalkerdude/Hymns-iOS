import SwiftUI
import Resolver

struct HomeContainerView: View {

    @State var selectedTab: HomeTab = .none

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: Resolver.resolve())
                    .tabItem {HomeTab.home.getImage(selectedTab == HomeTab.home).imageScale(.large)}
                    .tag(HomeTab.home)
                    .hideNavigationBar()

                BrowseView()
                    .tabItem { HomeTab.browse.getImage(selectedTab == HomeTab.browse).imageScale(.large)}
                    .tag(HomeTab.browse)
                    .hideNavigationBar()

                FavoritesView()
                    .tabItem {HomeTab.favorites.getImage(selectedTab == HomeTab.favorites).imageScale(.large)}
                    .tag(HomeTab.favorites)
                    .hideNavigationBar()

                SettingsView()
                    .tabItem {HomeTab.settings.getImage(selectedTab == HomeTab.settings).imageScale(.large)}
                    .tag(HomeTab.settings)
                    .hideNavigationBar()
            }.onAppear {
                if self.selectedTab == .none {
                    self.selectedTab = .home
                }
                if #available(iOS 13.4, *) {
                    self.iosAbove134 = true
                }
                UITabBar.appearance().unselectedItemTintColor = .label
            }
        }
    }
}

#if DEBUG
struct HomeContainerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // preview all tabs
            HomeContainerView(selectedTab: .home).previewDisplayName("Home tab")
            HomeContainerView(selectedTab: .browse).previewDisplayName("Browse tab")
            HomeContainerView(selectedTab: .favorites).previewDisplayName("Favorites tab")
            HomeContainerView(selectedTab: .settings).previewDisplayName("Settings tab")
            // preview localization
            HomeContainerView().environment(\.locale, .init(identifier: "de")).previewDisplayName("German")
            HomeContainerView().environment(\.locale, .init(identifier: "es")).previewDisplayName("Spanish")
            // preview different sizes
            HomeContainerView()
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")
            HomeContainerView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            HomeContainerView()
                .previewDevice(PreviewDevice(rawValue: "iPad Air 2"))
                .previewDisplayName("iPad Air 2")
            // preview dark mode
            HomeContainerView().environment(\.colorScheme, .dark).previewDisplayName("Dark mode")
        }
    }
}
#endif
