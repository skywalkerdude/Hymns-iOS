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
                Spacer()
                Text("Tap the ♡ on any hymn to add as a favorite")
                Spacer()
            } else {
                List(self.viewModel.favorites) { favorite in
                    NavigationLink(destination: favorite.destinationView) {
                        SongResultView(viewModel: favorite)
                    }
                }.resignKeyboardOnDragGesture()
            }
        }.onAppear {
            self.viewModel.fetchFavorites()
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
