import SwiftUI
import Resolver

struct HomeContainerView: View {

    @State var selectedTab: HomeTab = .none
    @State var showSplash: Bool = false

    var body: some View {
        Group { () -> AnyView in

            if showSplash {
                return SplashScreenView()
                    .opacity(showSplash ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                            self.showSplash = false
                        }
                }.eraseToAnyView()
            } else {
                return  NavigationView {
                    TabView(selection: self.$selectedTab) {
                        HomeView(viewModel: Resolver.resolve())
                            .tabItem {HomeTab.home.getImage(self.selectedTab == HomeTab.home).imageScale(.large)}
                            .tag(HomeTab.home)
                            .hideNavigationBar()

                        BrowseView()
                            .tabItem { HomeTab.browse.getImage(self.selectedTab == HomeTab.browse).imageScale(.large)}
                            .tag(HomeTab.browse)
                            .hideNavigationBar()

                        FavoritesView()
                            .tabItem {HomeTab.favorites.getImage(self.selectedTab == HomeTab.favorites).imageScale(.large)}
                            .tag(HomeTab.favorites)
                            .hideNavigationBar()

                        SettingsView()
                            .tabItem {HomeTab.settings.getImage(self.selectedTab == HomeTab.settings).imageScale(.large)}
                            .tag(HomeTab.settings)
                            .hideNavigationBar()
                    }.onAppear {
                        if self.selectedTab == .none {
                            self.selectedTab = .home
                        }
                        UITabBar.appearance().unselectedItemTintColor = .label
                    }
                }.eraseToAnyView()
            }
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
                UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                self.showSplash = true
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
