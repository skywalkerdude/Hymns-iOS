import SwiftUI
import Resolver

struct TagSheetView: View {

    @ObservedObject private var viewModel: TagSheetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var tagNames = ""

    init(viewModel: TagSheetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Label your tag")
                    Spacer()
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
                HStack {
                    TextField("Add tags", text: self.$tagNames)
                    Button("Add") {
                        self.viewModel.addTag(tagName: self.tagNames)
                    }.disabled(tagNames.isEmpty)
                }
            }
            if self.viewModel.tags.isEmpty {
                EmptyView()
            } else {
                Section {
                    HStack {
                        ForEach(self.viewModel.tags, id: \.self) { tag in
                            Button(action: {
                                //TODO FIX Delete is deleting all the tags because the button when clicked is clicking all of them.
                                self.viewModel.deleteTag(tagTitle: tag.title)
                            }, label: {
                                HStack {
                                    SongResultView(viewModel: tag)
                                    Image(systemName: "xmark.circle")
                                }
                            })
                                .padding()
                                .foregroundColor(.primary)
                                .background(Color.orange)
                                .cornerRadius(.infinity)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }.onAppear {
            self.viewModel.fetchHymn()
            self.viewModel.fetchTagsByHymn()
        }
    }
}

struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TagSheetView(viewModel: TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
    }
}
