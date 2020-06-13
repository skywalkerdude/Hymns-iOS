import SwiftUI
import UIKit

struct AboutUsInfoView: View {

    @State var showBfa = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Group {
            if showBfa {
                WebView(url: URL(string: "https://www.biblesforamerica.org/")!)
            } else {
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                        })
                        Text("About us").fontWeight(.bold).padding(.leading)
                        Spacer()
                    }.padding().padding(.top).foregroundColor(.primary)
                    HStack {
                        Text("Hello There 👋").font(.title).fontWeight(.bold)
                        Spacer()
                    }.padding()
                    Text("We're the team behind this hymnal app. We love Jesus, and we created this app as a free resource to help other believers access the thousands of hymns available on the internet. We also built in support for the hymns indexed by the Living Stream Ministry hymnal.")
                        .padding()
                    Text("Let the word of Christ dwell in you richly in all wisdom, teaching and admonishing one another with psalms and hymns and spiritual songs, singing with grace in your hearts to God.")
                        .padding()
                    HStack {
                        Spacer()
                        Text("- Col. 3:16").font(.callout).fontWeight(.bold).padding(.trailing)
                    }
                    // Cant get this dumb thing in line. It won't concatonate the text since it has a tapGesture.
                    // Right now the whole sentence will link you.
                    //https://stackoverflow.com/questions/59359730/is-it-possible-to-add-an-in-line-button-within-a-text
                    Group {
                        Text("To learn more about this study Bible visit the site ") + Text("here.").fontWeight(.bold).underline()
                    }
                    .onTapGesture {
                        self.showBfa = true
                    }.padding()
                    Spacer()
                }
            }
        }
    }
}

struct AbousInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AboutUsInfoView()
    }
}
