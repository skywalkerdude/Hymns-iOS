import SwiftUI

struct SongInfoDialog: View {

    @ObservedObject private var viewModel: SongInfoDialogViewModel
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    //https://stackoverflow.com/questions/58226892/does-swiftui-support-alternate-layouts-by-preferred-font-size
    let largeSizeCategories: [ContentSizeCategory] = [.extraExtraLarge,
                                                      .extraExtraExtraLarge,
                                                      .accessibilityMedium,
                                                      .accessibilityLarge,
                                                      .accessibilityExtraLarge,
                                                      .accessibilityExtraExtraLarge,
                                                      .accessibilityExtraExtraExtraLarge]

    init(viewModel: SongInfoDialogViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        if viewModel.songInfo.isEmpty {
            return ErrorView().eraseToAnyView()
        }

        if largeSizeCategories.contains(sizeCategory) {
            return ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.songInfo, id: \.self) { songInfo in
                        SongInfoView(viewModel: songInfo)
                    }
                }
            }.padding()
                .cornerRadius(5)
                .background(Color(.secondarySystemBackground))
                .eraseToAnyView()
        } else {
            return VStack(alignment: .leading, spacing: 15) {
                ForEach(viewModel.songInfo, id: \.self) { songInfo in
                    SongInfoView(viewModel: songInfo)
                }
            }
            .padding()
            .cornerRadius(5)
            .background(Color(.secondarySystemBackground))
            .eraseToAnyView()
        }
    }
}

#if DEBUG
struct SongInfoDialog_Previews: PreviewProvider {
    static var previews: some View {
        let emptyViewModel = SongInfoDialogViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        let empty = SongInfoDialog(viewModel: emptyViewModel)

        let dialogViewModel = SongInfoDialogViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        dialogViewModel.songInfo = [SongInfoViewModel(label: "Category", values: ["Worship of the Father"]),
                                    SongInfoViewModel(label: "Subcategory", values: ["As the Source of Life"]),
                                    SongInfoViewModel(label: "Author", values: ["Will Jeng", "Titus Ting"])]
        let dialog = SongInfoDialog(viewModel: dialogViewModel)

        let longValuesViewModel = SongInfoDialogViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn40)
        longValuesViewModel.songInfo = [SongInfoViewModel(label: "CategoryCategoryCategory", values: ["Worship Worship Worship of of of the the the Father Father Father"]),
                                        SongInfoViewModel(label: "SubcategorySubcategorySubcategory", values: ["As As As the the the Source Source Source of of of Life Life Life"]),
                                        SongInfoViewModel(label: "AuthorAuthorAuthor", values: ["Will Will Will Jeng Jeng Jeng", "Titus Titus Titus Ting Ting Ting"])]
        let longValues = SongInfoDialog(viewModel: longValuesViewModel)
        return Group {
            empty.previewLayout(.sizeThatFits).previewDisplayName("empty")
            dialog.toPreviews()
            longValues.previewLayout(.sizeThatFits).previewDisplayName("long values")
        }
    }
}
#endif
