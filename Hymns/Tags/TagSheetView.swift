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
            if !self.viewModel.tags.isEmpty {
                Section {
                    Text("Tags").font(.body).fontWeight(.bold)
                    HStack {
                        ForEach(self.viewModel.tags, id: \.self) { tag in
                            Button(action: {
                                self.viewModel.deleteTag(tagTitle: tag.title, tagColor: tag.color)
                            }, label: {
                                HStack {
                                    Text(tag.title).font(.body).fontWeight(.bold)
                                    Image(systemName: "xmark.circle")
                                }
                            }).padding(10).foregroundColor(tag.color.foreground)
                              .background(tag.color.background).cornerRadius(20)
                        }
                    }
                }.padding(.top).eraseToAnyView()
            }
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
        }.onAppear {
            self.viewModel.fetchHymn()
            self.viewModel.fetchTags()
        }.padding()
    }
}

#if DEBUG
struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist)
        viewModel.tags = [UiTag(title: "Tag 1", color: .blue),
                          UiTag(title: "Tag 1", color: .green),
                          UiTag(title: "Tag 1", color: .red),
                          UiTag(title: "Tag 1", color: .yellow),
                          UiTag(title: "Tag 2", color: .blue),
                          UiTag(title: "Tag 3", color: .blue),
                          UiTag(title: "Tag 4", color: .blue),
                          UiTag(title: "Tag 5", color: .blue)]
        return TagSheetView(viewModel: viewModel, sheet: Binding.constant(.tags))
    }
}
#endif
