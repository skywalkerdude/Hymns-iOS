import Resolver
import SwiftUI

enum BottomBarButton {
    case share(String)
    case fontSize
    case languages([SongResultViewModel])
    case musicPlayback(AudioPlayerViewModel)
    case relevant([SongResultViewModel])
    case tags
    case songInfo(SongInfoDialogViewModel)
}

extension BottomBarButton {

    var label: String {
        switch self {
        case .share:
            return NSLocalizedString("Share lyrics", comment: "Share lyrics externally to another app")
        case .fontSize:
            return NSLocalizedString("Change lyrics font size", comment: "Change the lyrics font size")
        case .languages:
            return NSLocalizedString("Change language", comment: "Change to another language")
        case .musicPlayback:
            return NSLocalizedString("Play music", comment: "Play the tune of the song")
        case .relevant:
            return NSLocalizedString("Go to relevant song", comment: "Go to a relevant song")
        case .tags:
            return NSLocalizedString("Tags", comment: "Browse or add tags for this song")
        case .songInfo:
            return NSLocalizedString("Song Info", comment: "See information for this song")
        }
    }

    var selectedLabel: some View {
        switch self {
        case .share:
            return BottomBarLabel(imageName: "square.and.arrow.up").foregroundColor(.primary)
        case .fontSize:
            return BottomBarLabel(imageName: "textformat.size").foregroundColor(.primary)
        case .languages:
            return BottomBarLabel(imageName: "globe").foregroundColor(.primary)
        case .musicPlayback:
            return BottomBarLabel(imageName: "play.fill").foregroundColor(.accentColor)
        case .relevant:
            return BottomBarLabel(imageName: "music.note.list").foregroundColor(.primary)
        case .tags:
            return BottomBarLabel(imageName: "tag").foregroundColor(.primary)
        case .songInfo:
            return BottomBarLabel(imageName: "info.circle").foregroundColor(.primary)
        }
    }

    var unselectedLabel: some View {
        switch self {
        case .share:
            return BottomBarLabel(imageName: "square.and.arrow.up").foregroundColor(.primary)
        case .fontSize:
            return BottomBarLabel(imageName: "textformat.size").foregroundColor(.primary)
        case .languages:
            return BottomBarLabel(imageName: "globe").foregroundColor(.primary)
        case .musicPlayback:
            return BottomBarLabel(imageName: "play").foregroundColor(.primary)
        case .relevant:
            return BottomBarLabel(imageName: "music.note.list").foregroundColor(.primary)
        case .tags:
            return BottomBarLabel(imageName: "tag").foregroundColor(.primary)
        case .songInfo:
            return BottomBarLabel(imageName: "info.circle").foregroundColor(.primary)
        }
    }
}

extension BottomBarButton: Identifiable {
    var id: String { self.label }
}

extension BottomBarButton: Equatable {
    static func == (lhs: BottomBarButton, rhs: BottomBarButton) -> Bool {
        switch (lhs, rhs) {
        case (.share(let lyrics1), share(let lyrics2)):
            return lyrics1 == lyrics2
        case (.fontSize, .fontSize):
            return true
        case (.languages(let viewModels1), .languages(let viewModels2)):
                return viewModels1 == viewModels2
        case (.musicPlayback, .musicPlayback):
            return true
        case (.relevant(let viewModels1), .relevant(let viewModels2)):
            return viewModels1 == viewModels2
        case (.tags, .tags):
            return true
        case (songInfo(let viewModel1), songInfo(let viewModel2)):
            return viewModel1.songInfo.count == viewModel2.songInfo.count
        default:
            return false
        }
    }
}

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
