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
    @State private var tabPresented: DisplayHymnActionSheet?
    @State private var sheetPresented: DisplayHymnSheet?
    @ObservedObject var viewModel: DisplayHymnBottomBarViewModel

    let userDefaultsManager: UserDefaultsManager = Resolver.resolve()

    var body: some View {
        HStack(spacing: 0) {
            Group {
                Spacer()
                Button(action: {
                    self.sheetPresented = .share
                }, label: {
                    BottomBarLabel(imageName: "square.and.arrow.up")
                    })
                    .sheet(item: $sheetPresented) { tab -> ShareSheet in
                        switch tab {
                        case .share:
                            return ShareSheet(activityItems: [self.viewModel.shareableLyrics])
                        }
                }
                Spacer()
            }
            Group {
                Button(action: {self.tabPresented = .fontSize}, label: {
                    BottomBarLabel(imageName: "textformat.size")
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
        }.onAppear {
            self.viewModel.fetchLyrics()
        }.actionSheet(item: $tabPresented) { tab -> ActionSheet in
            switch tab {
            case .fontSize:
                return
                    ActionSheet(
                        title: Text("Font size"),
                        message: Text("Change the song lyrics font size"),
                        buttons: [
                            .default(Text(FontSize.normal.rawValue),
                                     action: {
                                        self.userDefaultsManager.fontSize = .normal
                            }),
                            .default(Text(FontSize.large.rawValue),
                                     action: {
                                        self.userDefaultsManager.fontSize = .large
                            }),
                            .default(Text(FontSize.xlarge.rawValue),
                                     action: {
                                        self.userDefaultsManager.fontSize = .xlarge
                            }),
                            .cancel()])
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

enum DisplayHymnSheet: String {
    case share = "Share Lyrics"
}

extension DisplayHymnSheet: Identifiable {
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
