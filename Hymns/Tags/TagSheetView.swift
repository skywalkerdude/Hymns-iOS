import SwiftUI
import Resolver

struct TagSheetView: View {

    @ObservedObject private var viewModel: TagSheetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var tagNames = ""
    @State private var tagColor = TagColor.none
    @Binding var tagOn: Bool

    init(viewModel: TagSheetViewModel, tagOn: Binding<Bool>) {
        self.viewModel = viewModel
        self._tagOn = tagOn
    }

    var body: some View {
        VStack {
            HStack {
                Text("Name your tag").font(.body).fontWeight(.bold)
                Spacer()
            }
            HStack {
                TextField("Label it however you like", text: self.$tagNames)
            }
            Divider()
            SelectLabelView(tagColor: self.$tagColor)
            Group { () -> AnyView in
                guard let tags = self.viewModel.tags else {
                    return ActivityIndicator().maxSize().eraseToAnyView()
                }
                guard !tags.isEmpty else {
                    return EmptyView().eraseToAnyView()
                }
                return Section {
                    HStack {
                        Text("Tags").font(.body).fontWeight(.bold)
                        Spacer()
                    }.padding(.top)
                    HStack {
                        ForEach(tags, id: \.self) { tag in
                            Button(action: {
                                //TODO FIX Delete is deleting all the tags because the button when clicked is clicking all of them.
                                self.viewModel.deleteTag(tagTitle: tag.title, tagColor: .blue)
                            }, label: {
                                HStack {
                                    Text(tag.title).font(.body).fontWeight(.bold)
                                    Image(systemName: "xmark.circle")
                                }
                            })
                                .padding(10)
                                .foregroundColor(tag.color.foreground)
                                .background(tag.color.background)
                                .cornerRadius(20)
                                .lineLimit(1)
                        }
                    }
                }.eraseToAnyView()
            }
            HStack {
                Spacer()
                Button(action: {
                    self.tagOn.toggle()
                }, label: {
                    Text("Cancel").foregroundColor(.primary).fontWeight(.light)
                })
                Button("Add") {
                    self.viewModel.addTag(tagName: self.tagNames, tagColor: self.tagColor)
                }.padding(.horizontal).disabled(tagNames.isEmpty || (tagColor == .none))
            }.padding(.top)
        }.onAppear {
            self.viewModel.fetchHymn()
            self.viewModel.fetchTags()
        }.padding()
    }
}
