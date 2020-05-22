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

    @State private var tabPresented: DisplayHymnActionSheet?
    @State private var showingInfoDialog = false

    @ObservedObject private var viewModel: DisplayHymnBottomBarViewModel
    private let userDefaultsManager: UserDefaultsManager

    init(viewModel: DisplayHymnBottomBarViewModel, userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.viewModel = viewModel
        self.userDefaultsManager = userDefaultsManager
    }

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
                    self.showingInfoDialog = true
                }, label: {
                    BottomBarLabel(imageName: "info.circle")
                }).sheet(isPresented: $showingInfoDialog, content: {
                    SongInfoDialog(viewModel: self.viewModel.songInfo)
                })
                Spacer()
            }
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
                            })])
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
        return DisplayHymnBottomBar(viewModel: viewModel).toPreviews()
    }
}
#endif
