import SwiftUI

struct FavoritesView: View {
    var allHymns: [DummyHymnView] = testData

    var body: some View {
        VStack {
            HStack {
                Text("Favorites").customTitle()
                Spacer()
            }
            List(allHymns) { filtered in
                if !filtered.favorited {
                    Text(filtered.songTitle)
                }
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
