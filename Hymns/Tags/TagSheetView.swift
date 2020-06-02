import SwiftUI

//Core Data resources
//https://www.youtube.com/watch?v=7_Afen3PlDE
//https://www.youtube.com/watch?v=cuHzVt0VXJM
struct TagSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @State private var tagNames = ""
    var title: String
    var hymnIdentifier: HymnIdentifier
    var fetchRequest: FetchRequest<TaggedHymn>

    //@FetchRequest<TaggedHymn>(entity: TaggedHymn.entity(), sortDescriptors: []) var taggedHymn: FetchedResults<TaggedHymn>

    init(title: String, hymnIdentifier: HymnIdentifier) {
        fetchRequest = FetchRequest<TaggedHymn>(entity: TaggedHymn.entity(), sortDescriptors: [], predicate: NSPredicate(format: "songTitle BEGINSWITH %@", title))
        self.hymnIdentifier = hymnIdentifier
        self.title = title
    }

    var body: some View {
        Form {
            Section {
                Text("Label your tag")
                TextField("Add tags", text: self.$tagNames)
            }
            Button("ADD") {
                let newTag = TaggedHymn(context: self.moc)
                newTag.tagName = self.tagNames
                newTag.songTitle = self.title
                newTag.hymnIdentifier = FavoriteEntity.createPrimaryKey(hymnIdentifier: self.hymnIdentifier)
                try? self.moc.save()
                self.presentationMode.wrappedValue.dismiss()
            }
            Section {
                HStack {
                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { tag in
                        Button(action: {
                            //TODO: Tags should be deletable here.
                        }, label: {
                            HStack {
                                Text("\(tag.tagName ?? "" )")
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
    }
}

struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TagSheetView(title: "Lord's Table", hymnIdentifier: PreviewHymnIdentifiers.hymn1151)
    }
}
