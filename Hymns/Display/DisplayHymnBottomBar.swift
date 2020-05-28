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

    @Binding var dialogBuilder: (() -> AnyView)?
    @State private var actionSheet: ActionSheetItem?
    @State private var sheet: DisplayHymnSheet?

    // Navigating out of an action sheet requires another state variable
    // https://stackoverflow.com/questions/59454407/how-to-navigate-out-of-a-actionsheet
    @State private var languageIndexShown: Int?
  
    @State var mp3PlayerShown = false
    @State var playButtonOn = false

    @ObservedObject var viewModel: DisplayHymnBottomBarViewModel

    let userDefaultsManager: UserDefaultsManager = Resolver.resolve()

    var body: some View {
        VStack {
            if playButtonOn {
                viewModel.mp3Path.map { _ in
                    GeometryReader { geometry in
                        BottomSheetView(
                            isOpen: self.$mp3PlayerShown,
                            maxHeight: geometry.size.height * 1
                        ) {
                            AudioView(viewModel: AudioPlayerViewModel(item: self.viewModel.mp3Path))
                        }
                    }.frame(minHeight: 120, idealHeight: 120, maxHeight: 120.0)
                }
            }
            HStack(spacing: 0) {
                Group {
                    Spacer()
                    Button(action: {
                        self.sheet = .share
                    }, label: {
                        BottomBarLabel(imageName: "square.and.arrow.up")
                    })
                    Spacer()
                }
                Group {
                    Button(action: {self.actionSheet = .fontSize}, label: {
                        BottomBarLabel(imageName: "textformat.size")
                    })
                    Spacer()
                }
            if !viewModel.languages.isEmpty {
                Group {
                    Button(action: {
                        self.actionSheet = .languages
                    }, label: {
                        BottomBarLabel(imageName: "globe")
                    })
                    languageIndexShown.map { index in
                        NavigationLink(destination: self.viewModel.languages[index].destinationView,
                                       tag: index,
                                       selection: $languageIndexShown) {
                            EmptyView()
                        }
                    }
                    Spacer()
                }

                }
                Group {
                    Button(action: {}, label: {
                        BottomBarLabel(imageName: "tag")
                    })
                    Spacer()
                }
                Group {
                    Button(action: {
                        self.dialogBuilder = {
                            SongInfoDialog(viewModel: self.viewModel.songInfo).eraseToAnyView()
                        }
                    }, label: {
                        BottomBarLabel(imageName: "music.note.list")
                    })
                    Spacer()
                }
                Group {
                    Button(action: {
                        self.playButtonOn.toggle()
                    }, label: {
                        playButtonOn ? Image(systemName: "play.fill").accentColor(.accentColor) : Image(systemName: "play").accentColor(.primary)
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
                self.viewModel.fetchHymn()
            }.actionSheet(item: $actionSheet) { item -> ActionSheet in
                switch item {
                case .fontSize:
                    return
                        ActionSheet(
                            title: Text(item.rawValue),
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
                              case .languages:
                return
                    ActionSheet(
                        title: Text(item.rawValue),
                        message: Text("Change to another language"),
                        buttons: self.viewModel.languages.enumerated().map({ index, viewModel -> Alert.Button in
                            .default(Text(viewModel.title), action: {
                                self.languageIndexShown = index
                            })
                        }) + [.cancel()])

                }
            }.sheet(item: $sheet) { tab -> ShareSheet in
                switch tab {
                case .share:
                    return ShareSheet(activityItems: [self.viewModel.shareableLyrics])
                }
            }
        }
    }
}

private enum ActionSheetItem: String {
    case fontSize = "Lyrics font fize"
    case languages = "Languages"
}

extension ActionSheetItem: Identifiable {
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
        var dialogBuilder: (() -> AnyView)?
        return DisplayHymnBottomBar(dialogBuilder: Binding<(() -> AnyView)?>(
            get: {dialogBuilder},
            set: {dialogBuilder = $0}), viewModel: viewModel).toPreviews()
    }
}
#endif
