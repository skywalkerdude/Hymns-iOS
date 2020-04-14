import SwiftUI

struct FavoritesView: View {
    var allHymns: [DummyHymnView] = testData

    var body: some View {
        VStack {
            CustomTitle(title: "Favorites")
            List(allHymns) { filtered in
                if !filtered.favorited {
                    Text(filtered.songTitle)
                }
            }
        }.navigationBarTitle("", displayMode: .inline).navigationBarHidden(true)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
