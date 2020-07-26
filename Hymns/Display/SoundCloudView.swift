import SwiftUI

struct SoundCloudView: View {
    @State private var isLoading = true
    @Binding var showSoundCloud: Bool
    @Binding var soundCloudinitiated: Bool
    var searchTitle: String

    var body: some View {
        Group<AnyView> {
            guard let url = URL(string:
                "https://soundcloud.com/search?q=\(self.searchTitle)") else {
                    return ErrorView().eraseToAnyView()
            }
            return VStack {
                HStack(spacing: 20) {
                    Button(action: {
                        self.showSoundCloud = false
                        self.soundCloudinitiated = false
                    }, label: {
                        Image(systemName: "xmark.icloud").accentColor(.primary)
                    })
                    Button(action: {
                        self.showSoundCloud.toggle()
                    }, label: {
                        Image(systemName: "icloud.and.arrow.down").accentColor(.primary)
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
        SoundCloudView(showSoundCloud: .constant(true), soundCloudinitiated: .constant(true), searchTitle: "Jesus is Lord")
    }
}
