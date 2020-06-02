import SwiftUI

struct TagSubSelectionList: View {
    var fetchRequest: FetchRequest<TaggedHymn>
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { hymn in
            //TODO: Use hymn identifier to fetch hymn with another nav link
            HStack {
                Text("\(hymn.songTitle ?? "")")
                Spacer()
                Text("Hymn id stored" + (hymn.hymnIdentifier ?? ""))
            }
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<TaggedHymn>(entity: TaggedHymn.entity(), sortDescriptors: [], predicate: NSPredicate(format: "tagName BEGINSWITH %@", filter))
    }
}

struct TagSubSelectionList_Previews: PreviewProvider {
    static var previews: some View {
        TagSubSelectionList(filter: "hi")
    }
}
