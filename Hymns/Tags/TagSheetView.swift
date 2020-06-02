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
    
    var body: some View {
        Form {
            Section {
                Text("Label your tag")
                TextField("Add tags", text: self.$tagNames)
            }
            Section {
                Button("ADD") {
                    let newTag = TaggedHymn(context: self.moc)
                    newTag.tagName = self.tagNames
                    newTag.songTitle = self.title
                    newTag.hymnIdentifier = FavoriteEntity.createPrimaryKey(hymnIdentifier: self.hymnIdentifier)
                    try? self.moc.save()
                    self.presentationMode.wrappedValue.dismiss()
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
