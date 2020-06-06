import FirebaseAnalytics
import Resolver
import SwiftUI

struct FavoritesView: View {

    @ObservedObject private var viewModel: FavoritesViewModel

    init(viewModel: FavoritesViewModel = Resolver.resolve()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            CustomTitle(title: "Favorites")
            if self.viewModel.favorites.isEmpty {
                VStack(spacing: 25) {
                    Image("empty favorites illustration")
                    Text("Tap the heart on any hymn to add as a favorite")
                }.maxSize().offset(y: -25)
            } else {
                List(self.viewModel.favorites) { favorite in
                    NavigationLink(destination: favorite.destinationView) {
                        SongResultView(viewModel: favorite)
                    }
                }.resignKeyboardOnDragGesture()
            }
        }.onAppear {
            Analytics.setScreenName("FavoritesView", screenClass: "FavoritesViewModel")
            self.viewModel.fetchFavorites()
        }
    }
}

#if DEBUG
struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
#endif
