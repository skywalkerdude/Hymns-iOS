import SwiftUI

struct TagListView: View {
    @FetchRequest<TaggedHymn>(entity: TaggedHymn.entity(), sortDescriptors: []) var taggedHymn: FetchedResults<TaggedHymn>
    @State var unique = [String]()
    
    var body: some View {
        VStack {
            List {
                ForEach(self.unique, id: \.self) { hymn in
                    VStack<AnyView> {
                        NavigationLink(destination: TagSubSelectionList(filter: hymn)) {
                            Text(hymn)
                        }.eraseToAnyView()
                    }
                }
            }
        }.onAppear {
            self.storeUniqueTags(self.taggedHymn)
        }
    }
    
    //Takes all of the fetched hymnTags and stores only the unique tag names for us to iterate through
    private func storeUniqueTags(_ taggedHymn: FetchedResults<TaggedHymn>) {
        for hymn in self.taggedHymn {
            if self.unique.contains(hymn.tagName ?? "") {
                continue
            } else {
                self.unique.append(hymn.tagName ?? "")
            }
        }
    }
}

struct TagListView_Previews: PreviewProvider {
    static var previews: some View {
        TagListView()
    }
}
