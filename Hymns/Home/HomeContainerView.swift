import SwiftUI
import UIKit

struct HomeContainerView: View {
    
    @State var selectedTab: HomeTab = .home
    
    /*
    init() {
        guard let customFont = UIFont(name: "CustomFont-Light", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
     //   label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.adjustsFontForContentSizeCategory = true
    }
    */
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tabItem {
                HomeTab.home.getImage(selectedTab == HomeTab.home)
            }.accessibility(label: HomeTab.home.label).tag(HomeTab.home)

            BrowseView().tabItem {
                HomeTab.browse.getImage(selectedTab == HomeTab.browse)
            }.accessibility(label: HomeTab.browse.label).tag(HomeTab.browse)
            
            FavoritesView().tabItem {
                HomeTab.favorites.getImage(selectedTab == HomeTab.favorites)
            }.accessibility(label: HomeTab.favorites.label).tag(HomeTab.favorites)

            SettingsView().tabItem {
                HomeTab.settings.getImage(selectedTab == HomeTab.settings)
            }.accessibility(label: HomeTab.settings.label).tag(HomeTab.settings)
        }.onAppear {
            // Make the unselected tabs black insetad of grey.
            UITabBar.appearance().unselectedItemTintColor = .black
            //Change nav title font
            UINavigationBar.appearance().largeTitleTextAttributes = [
                       .foregroundColor: UIColor.black,
                       .font: UIFont(name: "Montserrat-SemiBold", size: 30)!]
            //TODO: This font size needs to be made dynamic
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
