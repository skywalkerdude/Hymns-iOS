import SwiftUI
import Resolver

struct TagSheetView: View {

    @ObservedObject private var viewModel: TagSheetViewModel
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    @Environment(\.presentationMode) var presentationMode
    @State private var tagName = ""
    @State private var tagColor = TagColor.none
    var sheet: Binding<DisplayHymnSheet?>

    init(viewModel: TagSheetViewModel, sheet: Binding<DisplayHymnSheet?>) {
        self.viewModel = viewModel
        self.sheet = sheet
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Button(action: {
                        self.sheet.wrappedValue = nil
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "xmark").foregroundColor(.primary)
                        }.padding()
                    })
                    if self.viewModel.tagsForHymn.isEmpty && self.viewModel.otherTags.isEmpty {
                        HStack {
                            Spacer()
                            Image("empty tag illustration")
                            Spacer()
                        }
                    }
                    if !self.viewModel.tagsForHymn.isEmpty {
                        Text("Tags").font(.headline).fontWeight(.bold)
                        WrappedHStack(items: self.$viewModel.tagsForHymn, geometry: geometry) { tag in
                            Button(action: {
                                self.viewModel.deleteTag(tagTitle: tag.title, tagColor: tag.color)
                            }, label: {
                                HStack {
                                    Text(tag.title).font(.body).fontWeight(.bold)
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .tagPill(backgroundColor: tag.color.background, foregroundColor: tag.color.foreground)
                            }).padding(2)
                        }
                    }
                    if self.viewModel.tagsForHymn.isEmpty && !self.viewModel.otherTags.isEmpty {
                        Text("Tags").font(.headline).fontWeight(.bold)
                        Text("\n ")
                    }
                    if !self.viewModel.otherTags.isEmpty {
                        Text("Add existing tags?").font(.headline).fontWeight(.bold)
                        WrappedHStack(items: self.$viewModel.otherTags, geometry: geometry) { tag in
                            Button(action: {
                                self.viewModel.addTag(tagTitle: tag.title, tagColor: tag.color)
                            }, label: {
                                Text(tag.title).font(.body).fontWeight(.bold)
                                    .tagPill(backgroundColor: tag.color.background, foregroundColor: tag.color.foreground)
                            }).padding(2)
                        }
                    }
                    Button(action: {
                        self.viewModel.showNewTagCreation.toggle()
                    }, label: {
                        HStack {
                            Text("Create a new tag").font(.headline).fontWeight(.bold)
                            Image(systemName: self.viewModel.showNewTagCreation ? "chevron.up" : "square.and.pencil")
                        }.foregroundColor(self.viewModel.showNewTagCreation ? .primary : .accentColor).padding(.vertical)
                    })

                    if self.viewModel.showNewTagCreation {
                        TextField("Label it however you like", text: self.$tagName)
                        ColorSelectorView(tagColor: self.$tagColor).padding(.vertical)
                        HStack {
                            Spacer()
                            Button(action: {
                                self.sheet.wrappedValue = nil
                            }, label: {
                                Text(NSLocalizedString("Close", comment: "Close button on the tag sheet"))
                                    .foregroundColor(.primary).fontWeight(.light)
                            })
                            Button("Add") {
                                self.viewModel.addTag(tagTitle: self.tagName, tagColor: self.tagColor)
                                self.tagName = ""
                            }.padding(.horizontal).disabled(self.tagName.isEmpty)
                        }.padding(.top)
                    }
                    Spacer()
                }.offset(y: self.kGuardian.slide)//.animation(.easeInOut(duration: 1.0))
            }
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
        noTagsViewModel.showNewTagCreation = true
        let noTags = TagSheetView(viewModel: noTagsViewModel, sheet: Binding.constant(.tags))

        let tagsForHymnViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        tagsForHymnViewModel.tagsForHymn = [UiTag(title: "Long tag name", color: .none),
                                            UiTag(title: "Tag 1", color: .green),
                                            UiTag(title: "Tag 1", color: .red),
                                            UiTag(title: "Tag 1", color: .yellow),
                                            UiTag(title: "Tag 2", color: .blue),
                                            UiTag(title: "Tag 3", color: .blue)]
        tagsForHymnViewModel.showNewTagCreation = true
        let tagsForHymn = TagSheetView(viewModel: tagsForHymnViewModel, sheet: Binding.constant(.tags))

        let otherTagsViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        otherTagsViewModel.otherTags = [UiTag(title: "Long tag name", color: .none),
                                        UiTag(title: "Tag 1", color: .green),
                                        UiTag(title: "Tag 1", color: .red),
                                        UiTag(title: "Tag 1", color: .yellow),
                                        UiTag(title: "Tag 2", color: .blue),
                                        UiTag(title: "Tag 3", color: .blue)]
        otherTagsViewModel.showNewTagCreation = true
        let otherTags = TagSheetView(viewModel: otherTagsViewModel, sheet: Binding.constant(.tags))

        let manyTagsViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        manyTagsViewModel.tagsForHymn = [UiTag(title: "Long tag name", color: .none),
                                         UiTag(title: "Tag 1", color: .green),
                                         UiTag(title: "Tag 1", color: .red),
                                         UiTag(title: "Tag 1", color: .yellow),
                                         UiTag(title: "Tag 2", color: .blue),
                                         UiTag(title: "Tag 3", color: .blue)]
        manyTagsViewModel.otherTags = [UiTag(title: "Another even longer tag name", color: .none),
                                       UiTag(title: "Tag 76", color: .green),
                                       UiTag(title: "Tag 7", color: .red)]
        let manyTags = TagSheetView(viewModel: manyTagsViewModel, sheet: Binding.constant(.tags))

        let manyTagsWithCreationViewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        manyTagsWithCreationViewModel.tagsForHymn = [UiTag(title: "Long tag name", color: .none),
                                                     UiTag(title: "Tag 1", color: .green),
                                                     UiTag(title: "Tag 1", color: .red),
                                                     UiTag(title: "Tag 1", color: .yellow),
                                                     UiTag(title: "Tag 2", color: .blue),
                                                     UiTag(title: "Tag 3", color: .blue)]
        manyTagsWithCreationViewModel.otherTags = [UiTag(title: "Another even longer tag name", color: .none),
                                                   UiTag(title: "Tag 76", color: .green),
                                                   UiTag(title: "T", color: .none)]
        manyTagsWithCreationViewModel.showNewTagCreation = true
        let manyTagsWithCreation = TagSheetView(viewModel: manyTagsWithCreationViewModel, sheet: Binding.constant(.tags))
        return Group {
            noTags.previewDisplayName("no tags")
            tagsForHymn.previewDisplayName("only tags for hymn exist")
            otherTags.previewDisplayName("only other tags exist")
            manyTags.previewDisplayName("many tags")
            manyTagsWithCreation.previewDisplayName("many tags with creation enabled")
        }.previewLayout(.sizeThatFits)
    }
}
#endif
