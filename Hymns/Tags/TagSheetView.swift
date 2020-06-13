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

                            //https://stackoverflow.com/questions/60960077/how-do-i-keep-multiple-button-actions-separate-in-swiftui-foreach-content Can't use a button here
                            HStack {
                                Text(tag.title).font(.body).fontWeight(.bold)
                                Image(systemName: "xmark.circle").onTapGesture {
                                    self.viewModel.deleteTag(tagTitle: tag.title, tagColor: .blue)
                                }
                            }
                            .padding(10)
                            .foregroundColor(tag.color.foreground)
                            .background(tag.color.background)
                            .cornerRadius(20)
                            .lineLimit(1)
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
