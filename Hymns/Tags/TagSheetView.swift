
import SwiftUI

//Core Data resources
//https://www.youtube.com/watch?v=7_Afen3PlDE
//https://www.youtube.com/watch?v=cuHzVt0VXJM
struct TagSheetView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var tagNames = ""
    private var title: String
    private var hymnIdentifier: HymnIdentifier

    init(title: String, hymnIdentifier: HymnIdentifier) {
//        fetchRequest = FetchRequest<TaggedHymn>(entity: TaggedHymn.entity(), sortDescriptors: [
//            NSSortDescriptor(keyPath: \TaggedHymn.tagName, ascending: true)
//        ], predicate: NSPredicate(format: "songTitle BEGINSWITH %@", title))
        self.hymnIdentifier = hymnIdentifier
        self.title = title
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
//                      //  let newTag = TaggedHymn(context: self.moc)
//                        newTag.tagName = self.tagNames
//                        newTag.songTitle = self.title
//                        newTag.hymnIdentifier = FavoriteEntity.createPrimaryKey(hymnIdentifier: self.hymnIdentifier)
//                      //  try? self.moc.save()
                    }
                }
            }
//                HStack {
//                    ForEach(self.fetchRequest.wrappedValue, id: \.self) { tag in
//                        Button(action: {
//                            //TODO: Delete button should only delete one tag instead of all of them
//                        }, label: {
//                            HStack {
//                                Text("\(tag.tagName ?? "" )")
//                                Image(systemName: "xmark.circle")
//                            }
//                        })
//                            .padding()
//                            .foregroundColor(.primary)
//                            .background(Color.orange)
//                            .cornerRadius(.infinity)
//                            .lineLimit(1)
//                    }
//                }

        }
    }
//    func deleteTag(tag: TaggedHymn) {
//        moc.delete(tag)
//
//        try? moc.save()
//    }
}

struct TagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TagSheetView(title: "Lord's Table", hymnIdentifier: PreviewHymnIdentifiers.hymn1151)
    }
}
