import SwiftUI
import Resolver

struct TagSheetView: View {

    @ObservedObject private var viewModel: TagSheetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var tagName = ""
    @State private var tagColor = TagColor.none
    @State private var showCreateFields = false
    var sheet: Binding<DisplayHymnSheet?>

    init(viewModel: TagSheetViewModel, sheet: Binding<DisplayHymnSheet?>) {
        self.viewModel = viewModel
        self.sheet = sheet
    }

    var body: some View {
        VStack(alignment: .leading) {
            if !self.viewModel.allTags.isEmpty {
                Text("Add your tags").font(.body).fontWeight(.bold)
            }
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        WrappedHStack(items: self.$viewModel.allTags, geometry: geometry) { tag in
                            Group {
                                if self.viewModel.tags.contains(tag) {

                                    Button(action: {
                                        self.viewModel.deleteTag(tagTitle: tag.title, tagColor: tag.color)
                                    }, label: {
                                        HStack {
                                            Text(tag.title).font(.body).fontWeight(.bold)
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                        .tagPill(backgroundColor: tag.color.background, foregroundColor: tag.color.foreground)
                                    }).padding(2)
                                } else {
                                    Button(action: {
                                        self.viewModel.addTag(tagTitle: tag.title, tagColor: tag.color)
                                        // self.viewModel.deleteTag(tagTitle: tag.title, tagColor: tag.color)
                                    }, label: {
                                        HStack {
                                            Text(tag.title).font(.body)//.fontWeight(.no)
                                            //   Image(systemName: "xmark.circle")
                                        }
                                        .tagPill(backgroundColor: tag.color.background, foregroundColor: tag.color.foreground, showBorder: false)
                                    }).padding(2)
                                }
                            }
                        }
                        Text("Create a new tag").font(.body).fontWeight(.bold)
                        TextField("Label it however you like", text: self.$tagName).onTapGesture {
                            self.showCreateFields = true
                        }
                        Divider()
                        if self.showCreateFields {
                            ColorSelectorView(tagColor: self.$tagColor).padding(.vertical)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                self.sheet.wrappedValue = nil
                            }, label: {
                                Text("Close").foregroundColor(.primary).fontWeight(.light)
                            })
                            if self.showCreateFields {
                                Button("Add") {
                                    self.viewModel.addTag(tagTitle: self.tagName, tagColor: self.tagColor)
                                    self.viewModel.fetchUniqueTags()
                                }.padding(.horizontal).disabled(self.tagName.isEmpty)
                            }
                        }.padding(.top)
                    }
                }
            }
            Spacer()
        }.onAppear {
            self.viewModel.fetchHymn()
            self.viewModel.fetchTags()
            self.viewModel.fetchUniqueTags()
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
            noTags.previewDisplayName("no tags")
            oneTag.previewDisplayName("one tag")
            manyTags.previewDisplayName("many tags")
        }.previewLayout(.sizeThatFits)
    }
}
#endif
