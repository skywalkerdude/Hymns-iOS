import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var store: Store

    var allHymns: [DummyHymnView] = testData

    var body: some View {
        VStack {
            CustomTitle(title: "Favorites")
            List {
                ForEach(store.itemEntities) { (itemEntity: FavoritedEntity) in
                    if itemEntity.isInvalidated {
                        EmptyView()
                    } else {

                        NavigationLink(destination: DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: HymnIdentifier(hymnType: HymnType.fromAbbreviatedValue(abbreviatedValue: itemEntity.hymnType)!, hymnNumber: itemEntity.hymnNumber)))
                       ) {
                        HStack {
                            Text("Hymn \(itemEntity.hymnNumber)")
                        }
                        }
                    }
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
