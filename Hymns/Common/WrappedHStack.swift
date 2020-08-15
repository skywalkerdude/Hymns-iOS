import SwiftUI

// https://stackoverflow.com/a/58876712/1907538
struct WrappedHStack<Item: Hashable, Content: View>: View {

    @Binding var items: [Item]
    let geometry: GeometryProxy
    let viewBuilder: (Item) -> Content

    @State private var structuredItems = [[Item]]()
    @State private var flattenedItems = [Item]()

    private func containsSameElements(_ list1: [Item], _ list2: [Item]) -> Bool {
        if list1.count != list2.count {
            return false
        }
        return Array(Set(list1).intersection(list2)).count == list1.count
    }

    var body: some View {
        guard let firstItem = self.items.first else {
            return EmptyView().eraseToAnyView()
        }

        guard let lastItem = self.items.last else {
            return EmptyView().eraseToAnyView()
        }

        var lists = [[Item]]()

        var currentList = [Item]()
        var width = CGFloat.zero

        if !containsSameElements(self.flattenedItems, self.items) {
            return ZStack(alignment: .topLeading) {
                ForEach(self.items, id: \.self) { item in
                    self.viewBuilder(item).alignmentGuide(.leading, computeValue: { dimension in
                        if item == firstItem {
                            currentList = [item]
                            width = dimension.width
                        } else if width + dimension.width > self.geometry.size.width {
                            lists.append(currentList)
                            currentList = [item]
                            width = dimension.width
                        } else {
                            currentList.append(item)
                            width += dimension.width
                        }

                        if item == lastItem {
                            lists.append(currentList)
                        }
                        return 0
                    })
                }.anchorPreference(key: AnchorCalculatedKey.self, value: .bounds) { _ in
                    print("booyah \(self.items), lists: \(lists)")
                    return true
                }
            }.onPreferenceChange(AnchorCalculatedKey.self) { _ in
                self.structuredItems = lists
                self.flattenedItems = lists.reduce(into: [Item]()) { listSoFar, list in
                    for item in list {
                        if !listSoFar.contains(item) {
                            listSoFar.append(item)
                        }
                    }
                }
            }.eraseToAnyView()
        } else {
            var seenItems = [Item]()
            return VStack(alignment: .leading) {
                ForEach(self.structuredItems, id: \.self) { list in
                    HStack {
                        ForEach(list, id: \.self) { item in
                            Group { () -> AnyView in
                                if seenItems.contains(item) {
                                    return EmptyView().eraseToAnyView()
                                } else {
                                    seenItems.append(item)
                                    return self.viewBuilder(item).eraseToAnyView()
                                }
                            }
                        }
                    }
                }
            }.eraseToAnyView()
        }
    }
}

/**
 * Keeps track if the Anchor preference has finished calculated yet
 */
struct AnchorCalculatedKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value.toggle()
    }
}

struct BindingPreference: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

#if DEBUG
struct WrappedHStack_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            GeometryReader { geometry in
                WrappedHStack(items: Binding.constant([String]()), geometry: geometry) { item in
                    Text(item)
                }
            }
            GeometryReader { geometry in
                WrappedHStack(items: Binding.constant([
                    "Multiline really relaly long tag name that takes up many lines. So many lines, in fact, that it could be three lines.",
                    "Nintendo", "XBox", "PlayStation", "Playstation 2", "Playstaition 3", "Stadia", "Oculus"]), geometry: geometry) { platform in
                        Button(action: {}, label: {
                            HStack {
                                Text(platform).font(.body).fontWeight(.bold)
                                Image(systemName: "xmark.circle")
                            }.padding(7).foregroundColor(Color.white).background(Color.purple).cornerRadius(15)
                        })
                }
            }
        }.previewLayout(.sizeThatFits)
    }
}
#endif
