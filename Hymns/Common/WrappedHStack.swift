import SwiftUI

// https://stackoverflow.com/a/58876712/1907538
struct WrappedHStack<Item: Hashable, Content: View>: View {

    @Binding var items: [Item]
    let geometry: GeometryProxy
    let viewBuilder: (Item) -> Content

    var body: some View {
        guard let lastItem = self.items.last else {
            return EmptyView().eraseToAnyView()
        }

        var width = CGFloat.zero
        var height = CGFloat.zero

        return
            ZStack(alignment: .topLeading) {
                ForEach(self.items, id: \.self) { item in
                    self.viewBuilder(item).alignmentGuide(.leading, computeValue: { dimension in
                        if abs(width - dimension.width) > self.geometry.size.width {
                            width = 0
                            height -= dimension.height + 5
                        }
                        let result = width
                        if item == lastItem {
                            width = 0 //last item
                        } else {
                            width -= dimension.width + 5
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
            }.eraseToAnyView()
    }
}

struct WrappedHStack_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            GeometryReader { geometry in
                WrappedHStack(items: Binding.constant([String]()), geometry: geometry) { item in
                    Text(item)
                }
            }
            GeometryReader { geometry in
                WrappedHStack(items: Binding.constant(["Nintendo", "XBox", "PlayStation", "Playstation 2", "Playstaition 3", "Stadia", "Oculus"]), geometry: geometry) { platform in
                    Button(action: {}, label: {
                        HStack {
                            Text(platform).font(.body).fontWeight(.bold)
                            Image(systemName: "xmark.circle")
                        }.padding(10).foregroundColor(Color.white).background(Color.purple).cornerRadius(20)
                    })
                }
            }
        }.previewLayout(.sizeThatFits)
    }
}
