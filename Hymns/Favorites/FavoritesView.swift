import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel = FavoritesViewModel()

    var body: some View {
        VStack {
            CustomTitle(title: "Favorites")
            List {
                ForEach(viewModel.itemEntities) { (itemEntity: FavoritedEntity) in
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
