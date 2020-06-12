import SwiftUI
import UIKit

struct AbousUsInfoView: View {
    @State var webView = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Group<AnyView> {
                if webView {
                    return WebView(url: URL(string: "https://online.recoveryversion.bible/")!).eraseToAnyView()
                } else {
                    return  VStack {
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Image(systemName: "xmark")
                            })
                            Text("About us").fontWeight(.bold)
                            Spacer()
                        }.padding().padding(.top).foregroundColor(.primary)
                        HStack {
                            Text("Hello There 👋").font(.largeTitle).fontWeight(.bold)
                            Spacer()
                        }.padding()
                        Text("We are a group of Christians who love Jesus Christ. We created this app as a free resource to help people easily access hymns. Many of these hymns are inspired by verses from the Recovery Version Study Bible.").padding()
                        Text("Let the word of Christ dwell in you richly in all wisdom, teaching and admonishing one another with psalms and hymns and spiritual songs, singing with grace in your hearts to God.").padding()
                        HStack {
                            Spacer()
                            Text("- Col. 3:16").font(.callout).fontWeight(.bold).padding()
                        }
                        //Cant get this dumb thing in line. It won't concatonate the text since it has a tapGesture. Right now the whole sentence will link you. //https://stackoverflow.com/questions/59359730/is-it-possible-to-add-an-in-line-button-within-a-text
                        Group {
                            Text("To learn more about this study Bible visit the site") + Text(" here.").fontWeight(.bold).underline()
                        }
                        .onTapGesture {
                            self.webView = true
                        }.padding()
                        Spacer()
                    }.eraseToAnyView()
                }
            }
        }
    }
}

struct AbousInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AbousUsInfoView()
    }
}
