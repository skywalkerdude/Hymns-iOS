import SwiftUI

// https://stackoverflow.com/a/58876712/1907538
struct WrappedHStack<Item: Hashable, Content: View>: View {
    
    var view: TagSheetView
    @Binding var items: [Item]
    let viewBuilder: (Item) -> Content
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        guard let lastItem = self.items.last else {
            return EmptyView().eraseToAnyView()
        }
        
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return VStack {
            ZStack(alignment: .topLeading) {
                ForEach(self.items, id: \.self) { item in
                    self.viewBuilder(item).alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > geometry.size.width {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if item == lastItem {
                            width = 0 //last item
                        } else {
                            width -= dimension.width
                        }
                        return result
                    }).alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == lastItem {
                            height = 0 // last item
                        }
                        return result
                    })
                }
            }
            HStack {
                Spacer()
                Button(action: {
                    self.view.sheet.wrappedValue = nil
                }, label: {
                    Text("Cancel").foregroundColor(.primary).fontWeight(.light)
                })
                Button("Add") {
                    self.view.viewModel.addTag(tagTitle: self.view.tagName, tagColor: self.view.tagColor)
                }.padding(.horizontal).disabled(self.view.tagName.isEmpty)
            }.padding(.top)
        }.eraseToAnyView()
    }
}

struct WrappedHStack_Previews: PreviewProvider {
    static var previews: some View {
        let empty =
            WrappedHStack(view: TagSheetView(viewModel: TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist), sheet: Binding.constant(.tags)), items: Binding.constant(["aww"])) { item in
                Text(item)
        }
        let platforms =
            WrappedHStack(view: TagSheetView(viewModel: TagSheetViewModel(hymnToDisplay: PreviewHymnIdentifiers.cupOfChrist), sheet: Binding.constant(.tags)), items: Binding.constant(["Nintendo", "XBox", "PlayStation", "Playstation 2", "Playstaition 3", "Stadia", "Oculus"])) { platform in
                Button(action: {}, label: {
                    HStack {
                        Text(platform).font(.body).fontWeight(.bold)
                        Image(systemName: "xmark.circle")
                    }.padding(10).cornerRadius(20)
                })
        }
        return Group {
            empty
            platforms
        }.previewLayout(.sizeThatFits)
    }
}
