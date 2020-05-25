import Resolver
import SwiftUI

struct BottomBarLabel: View {

    let imageName: String

    var body: some View {
        Image(systemName: imageName).foregroundColor(.primary).padding()
    }
}

#if DEBUG
struct BottomBarLabel_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarLabel(imageName: "music.note.list").previewLayout(.sizeThatFits)
    }
}
#endif

struct DisplayHymnBottomBar: View {

    @Binding var contentBuilder: (() -> AnyView)?

    @ObservedObject var viewModel: DisplayHymnBottomBarViewModel

    var body: some View {
        HStack(spacing: 0) {
            Group {
                Spacer()
                Button(action: {}, label: {
                    BottomBarLabel(imageName: "square.and.arrow.up")
                })
                Spacer()
            }
            Group {
                Button(action: {}, label: {
                    BottomBarLabel(imageName: "globe")
                })
                Spacer()
            }
            Group {
                Button(action: {}, label: {
                    BottomBarLabel(imageName: "tag")
                })
                Spacer()
            }
            Group {
                Button(action: {}, label: {
                    BottomBarLabel(imageName: "music.note.list")
                })
                Spacer()
            }
            Group {
                Button(action: {}, label: {
                    BottomBarLabel(imageName: "play")
                })
                Spacer()
            }
            Group {
                Button(action: {
                    self.contentBuilder = {
                        SongInfoDialog(viewModel: self.viewModel.songInfo).eraseToAnyView()
                    }
                }, label: {
                    BottomBarLabel(imageName: "info.circle")
                })
                Spacer()
            }
        }
    }
}

enum DisplayHymnActionSheet: String {
    case fontSize = "Lyrics font fize"
}

extension DisplayHymnActionSheet: Identifiable {
    var id: String {
        rawValue
    }
}

#if DEBUG
struct DisplayHymnBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = DisplayHymnBottomBarViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151)
        var contentBuilder: (() -> AnyView)?
        return DisplayHymnBottomBar(contentBuilder: Binding<(() -> AnyView)?>(
            get: {contentBuilder},
            set: {contentBuilder = $0}), viewModel: viewModel).toPreviews()
    }
}
#endif
