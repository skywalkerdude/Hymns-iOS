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
    case soundCloud(URL)
    case youTube(URL)
}

extension BottomBarButton {

    var label: String {
        switch self {
        case .share:
            return NSLocalizedString("Share lyrics", comment: "Share lyrics externally to another app")
        case .fontSize:
            return NSLocalizedString("Change lyrics font size", comment: "Change the lyrics font size")
        case .languages:
            return NSLocalizedString("Show languages", comment: "Show different languages for this song")
        case .musicPlayback:
            return NSLocalizedString("Play music", comment: "Play the tune of the song")
        case .relevant:
            return NSLocalizedString("Relevant songs", comment: "Songs relevant to this song (alternate tunes, etc)")
        case .tags:
            return NSLocalizedString("Tags", comment: "Browse or add tags for this song")
        case .songInfo:
            return NSLocalizedString("Song Info", comment: "See information for this song")
        case .soundCloud:
            return NSLocalizedString("Search in SoundCloud", comment: "Search for this song on SoundCloud")
        case .youTube:
            return NSLocalizedString("Search in YouTube", comment: "Search for this song on YouTube")
        }
    }

    var selectedLabel: some View {
        switch self {
        case .share:
            return BottomBarLabel(imageName: "square.and.arrow.up", a11yLabel: label).foregroundColor(.primary)
        case .fontSize:
            return BottomBarLabel(imageName: "textformat.size", a11yLabel: label).foregroundColor(.primary)
        case .languages:
            return BottomBarLabel(imageName: "globe", a11yLabel: label).foregroundColor(.primary)
        case .musicPlayback:
            return BottomBarLabel(imageName: "play.fill", a11yLabel: label).foregroundColor(.accentColor)
        case .relevant:
            return BottomBarLabel(imageName: "music.note.list", a11yLabel: label).foregroundColor(.primary)
        case .tags:
            return BottomBarLabel(imageName: "tag", a11yLabel: label).foregroundColor(.primary)
        case .songInfo:
            return BottomBarLabel(imageName: "info.circle", a11yLabel: label).foregroundColor(.primary)
        case .soundCloud:
            return BottomBarLabel(imageName: "cloud", a11yLabel: label).foregroundColor(.primary)
        case .youTube:
            return BottomBarLabel(imageName: "play.rectangle", a11yLabel: label).foregroundColor(.primary)
        }
    }

    var unselectedLabel: some View {
        switch self {
        case .share:
            return BottomBarLabel(imageName: "square.and.arrow.up", a11yLabel: label).foregroundColor(.primary)
        case .fontSize:
            return BottomBarLabel(imageName: "textformat.size", a11yLabel: label).foregroundColor(.primary)
        case .languages:
            return BottomBarLabel(imageName: "globe", a11yLabel: label).foregroundColor(.primary)
        case .musicPlayback:
            return BottomBarLabel(imageName: "play", a11yLabel: label).foregroundColor(.primary)
        case .relevant:
            return BottomBarLabel(imageName: "music.note.list", a11yLabel: label).foregroundColor(.primary)
        case .tags:
            return BottomBarLabel(imageName: "tag", a11yLabel: label).foregroundColor(.primary)
        case .songInfo:
            return BottomBarLabel(imageName: "info.circle", a11yLabel: label).foregroundColor(.primary)
        case .soundCloud:
            return BottomBarLabel(imageName: "cloud", a11yLabel: label).foregroundColor(.primary)
        case .youTube:
            return BottomBarLabel(imageName: "play.rectangle.fill", a11yLabel: label).foregroundColor(.primary)
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
        case (soundCloud(let url1), soundCloud(let url2)):
            return url1 == url2
        case (youTube(let url1), youTube(let url2)):
            return url1 == url2
        default:
            return false
        }
    }
}

struct BottomBarLabel: View {

    let imageName: String
    let a11yLabel: String

    var body: some View {
        Image(systemName: imageName).accessibility(label: Text(a11yLabel)).font(.system(size: smallButtonSize)).padding()
    }
}

#if DEBUG
struct BottomBarLabel_Previews: PreviewProvider {
    static var previews: some View {
        BottomBarLabel(imageName: "music.note.list", a11yLabel: "Accessibility label here").previewLayout(.sizeThatFits)
    }
}
#endif
