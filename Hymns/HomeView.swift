import SwiftUI

struct HomeView: View {
    // Whenever I put this init into HomeScreenView it does not work. Why that is I have no idea...
    //Currently we have to use UIKIT to change the unselected tabicons from grey to black.
    init() {
         UITabBar.appearance().unselectedItemTintColor = UIColor.black
     }
    
    var body: some View {
        NavigationView {
            HomeSearchView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
