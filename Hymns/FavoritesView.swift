import SwiftUI

struct FavoritesView: View {
    var allHymns: [DummyHymnView] = testData

    var body: some View {
        NavigationView {
            List(allHymns) { filtered in
                if !filtered.favorited {
                    Text(filtered.songTitle)
                }
            }.navigationBarTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
