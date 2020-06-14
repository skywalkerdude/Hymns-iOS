import SwiftUI
import Resolver

struct TagSheetView: View {

    @ObservedObject private var viewModel: TagSheetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var tagName = ""
    @State private var tagColor = TagColor.none
    var sheet: Binding<DisplayHymnSheet?>

    init(viewModel: TagSheetViewModel, sheet: Binding<DisplayHymnSheet?>) {
        self.viewModel = viewModel
        self.sheet = sheet
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Name your tag").font(.body).fontWeight(.bold)
            TextField("Label it however you like", text: self.$tagName)
            Divider()
            ColorSelectorView(tagColor: self.$tagColor).padding(.vertical)
            HStack {
                Spacer()
                Button(action: {
                    self.sheet.wrappedValue = nil
                }, label: {
                    Text("Cancel").foregroundColor(.primary).fontWeight(.light)
                })
                Button("Add") {
                    self.viewModel.addTag(tagTitle: self.tagName, tagColor: self.tagColor)
                }.padding(.horizontal).disabled(tagName.isEmpty)
            }.padding(.top)
            if !self.viewModel.tags.isEmpty {
                Section {
                    Text("Tags").font(.body).fontWeight(.bold)
                    WrappedHStack(items: self.$viewModel.tags) { tag in
                        Button(action: {
                            self.viewModel.deleteTag(tagTitle: tag.title, tagColor: tag.color)
                        }, label: {
                            HStack {
                                Text(tag.title).font(.body).fontWeight(.bold)
                                Image(systemName: "xmark.circle")
                            }
                            .tagPill(backgroundColor: tag.color.background, foregroundColor: tag.color.foreground)
                            }).padding(5)
                    }
                }
            }
            Spacer()
        }.onAppear {
            self.viewModel.fetchHymn()
            self.viewModel.fetchTags()
        }.padding()
    }
}

#if DEBUG
struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let noTagsViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        let noTags = TagSheetView(viewModel: noTagsViewModel, sheet: Binding.constant(.tags))

        let oneTagViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        oneTagViewModel.tags = [UiTag(title: "Lord's table", color: .green)]
        let oneTag = TagSheetView(viewModel: oneTagViewModel, sheet: Binding.constant(.tags))

        let manyTagsViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        manyTagsViewModel.tags = [UiTag(title: "Long tag name", color: .none),
                          UiTag(title: "Tag 1", color: .green),
                          UiTag(title: "Tag 1", color: .red),
                          UiTag(title: "Tag 1", color: .yellow),
                          UiTag(title: "Tag 2", color: .blue),
                          UiTag(title: "Tag 3", color: .blue)]
        let manyTags = TagSheetView(viewModel: manyTagsViewModel, sheet: Binding.constant(.tags))
        return Group {
            noTags
            oneTag
            manyTags
        }.previewLayout(.sizeThatFits)
    }
}
#endif
