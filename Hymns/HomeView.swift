import SwiftUI

struct HomeView: View {
    
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
