import SwiftUI

struct SoundCloudView: View {
    @State private var isLoading = true
    @Binding var showSoundCloud: Bool
    @Binding var soundCloudinitiated: Bool
    @Binding var shrink: Bool
    var searchTitle: String

    var body: some View {
        Group<AnyView> {
            guard let url =
                "https://soundcloud.com/search?q=\(self.searchTitle)".toEncodedUrl else {
                    return ErrorView().eraseToAnyView()
            }
            return VStack {
                HStack(spacing: 10) {
                    Button(action: {
                        self.showSoundCloud = false
                        self.soundCloudinitiated = false
                    }, label: {
                        Image(systemName: "xmark.square.fill").accentColor(.red)
                    })
                    Button(action: {
                        self.showSoundCloud.toggle()
                        self.shrink = true
                        print("bbug shrink", self.shrink)
                    }, label: {
                        Image(systemName: "minus.square.fill").accentColor(.accentColor)
                    })
                    Spacer()
                }.padding()
                ZStack {
                    SoundCloudWebView(isLoading: self.$isLoading, url: url).eraseToAnyView().opacity(isLoading ? 0 : 1)
                    ActivityIndicator().maxSize().eraseToAnyView().opacity(isLoading ? 1 : 0)
                }
            }
            .eraseToAnyView()
        }
    }
}

struct SoundCloudView_Previews: PreviewProvider {
    static var previews: some View {
        SoundCloudView(showSoundCloud: .constant(true), soundCloudinitiated: .constant(true), shrink: .constant(true), searchTitle: "Jesus is Lord")
    }
}
