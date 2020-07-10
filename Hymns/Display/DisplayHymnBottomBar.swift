import Resolver
import SwiftUI

struct BottomBarLabel: View {

    let imageName: String

    var body: some View {
        Image(systemName: imageName).font(.system(size: smallButtonSize)).padding()
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
    @State private var relevantIndexShown: Int?

    @State var showAudioPlayer = false

    @ObservedObject var viewModel: DisplayHymnBottomBarViewModel
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    let userDefaultsManager: UserDefaultsManager = Resolver.resolve()

    var body: some View {
        VStack {
            if showAudioPlayer {
                viewModel.audioPlayer.map { audioPlayer in
                    VStack {
                        Divider()
                        AudioPlayer(viewModel: audioPlayer).padding()
                    }
                }
            }
            HStack(spacing: 0) {
                Group {
                    Spacer()
                    Button(action: {
                        self.sheet = .share
                    }, label: {
                        BottomBarLabel(imageName: "square.and.arrow.up").foregroundColor(.primary)
                    })
                    Spacer()
                }
                Group {
                    Button(action: {self.actionSheet = .fontSize}, label: {
                        BottomBarLabel(imageName: "textformat.size").foregroundColor(.primary)
                    })
                    Spacer()
                }
                if !viewModel.languages.isEmpty {
                    Group {
                        Button(action: {
                            self.actionSheet = .languages
                        }, label: {
                            BottomBarLabel(imageName: "globe").foregroundColor(.primary)
                        })
                        languageIndexShown.map { index in
                            PushView(destination: self.viewModel.languages[index].destinationView,
                                     tag: index,
                                     selection: $languageIndexShown) {
                                        EmptyView()
                            }
                        }
                        Spacer()
                    }
                }
                Group {
                    Button(action: {
                        self.sheet = .tags
                    }, label: {
                        BottomBarLabel(imageName: "tag").foregroundColor(.primary)
                    })
                    Spacer()
                }
                if !viewModel.relevant.isEmpty {
                    Group {
                        Button(action: {
                            self.actionSheet = .relevant
                        }, label: {
                            BottomBarLabel(imageName: "music.note.list").foregroundColor(.primary)
                        })
                        relevantIndexShown.map { index in
                            PushView(destination: self.viewModel.relevant[index].destinationView,
                                     tag: index,
                                     selection: $relevantIndexShown) {
                                        EmptyView()
                            }
                        }
                        Spacer()
                    }
                }
                Group {
                    viewModel.audioPlayer.map { _ in
                        Button(action: {
                            self.showAudioPlayer.toggle()
                        }, label: {
                            showAudioPlayer ?
                                BottomBarLabel(imageName: "play.fill").foregroundColor(.accentColor) :
                                BottomBarLabel(imageName: "play").foregroundColor(.primary)
                        })
                    }
                    Spacer()
                }
                if !viewModel.songInfo.songInfo.isEmpty {
                    Group {
                        Button(action: {
                            if self.sizeCategory.isAccessibilityCategory() {
                                self.sheet = .songInfo
                            } else {
                                self.dialogBuilder = {
                                    SongInfoDialogView(viewModel: self.viewModel.songInfo).eraseToAnyView()
                                }
                            }
                        }, label: {
                            BottomBarLabel(imageName: "info.circle").foregroundColor(.primary)
                        })
                        Spacer()
                    }
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
                case .relevant:
                    return
                        ActionSheet(
                            title: Text(item.rawValue),
                            message: Text("Change to a relevant hymn"),
                            buttons: self.viewModel.relevant.enumerated().map({ index, viewModel -> Alert.Button in
                                .default(Text(viewModel.title), action: {
                                    self.relevantIndexShown = index
                                })
                            }) + [.cancel()])
                }
            }.sheet(item: $sheet) { tab -> AnyView in
                switch tab {
                case .share:
                    return ShareSheet(activityItems: [self.viewModel.shareableLyrics]).eraseToAnyView()
                case .tags:
                    return TagSheetView(viewModel: TagSheetViewModel(hymnToDisplay: self.viewModel.identifier), sheet: self.$sheet).eraseToAnyView()
                // Case only used for large accesability
                case .songInfo:
                    return SongInfoSheetView(viewModel: self.viewModel.songInfo).eraseToAnyView()
                }
            }
        }.background(Color(.systemBackground))
    }
}

private enum ActionSheetItem: String {
    case fontSize = "Lyrics font size"
    case languages = "Languages"
    case relevant = "Relevant songs"
}

extension ActionSheetItem: Identifiable {
    var id: String {
        rawValue
    }
}

enum DisplayHymnSheet: String {
    case share = "Share Lyrics"
    case tags = "Tags"
    case songInfo = "Song Info"
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
        viewModel.songInfo.songInfo = [SongInfoViewModel(label: "label", values: ["values"])]
        viewModel.languages = [SongResultViewModel(title: "language", destinationView: EmptyView().eraseToAnyView())]
        viewModel.relevant = [SongResultViewModel(title: "relevant", destinationView: EmptyView().eraseToAnyView())]
        viewModel.audioPlayer = AudioPlayerViewModel(url: URL(string: "https://www.hymnal.net/Hymns/NewSongs/mp3/ns0767.mp3")!)
        var dialogBuilder: (() -> AnyView)?
        return DisplayHymnBottomBar(dialogBuilder: Binding<(() -> AnyView)?>(
            get: {dialogBuilder},
            set: {dialogBuilder = $0}), viewModel: viewModel).previewLayout(.sizeThatFits)
    }
}
#endif
