import SwiftUI

enum DetailToolbar {
    case info
    case share
    case textSize
    case tags
    case tune
    case musicPlayer
}

extension DetailToolbar {
    var label: Text {
        switch self {
        case .info:
            return Text("Info button")
        case .share:
            return Text("Share button")
        case .textSize:
            return Text("Text size button")
        case .tags:
            return Text("Tags button")
        case .tune:
            return Text("Tune button")
        case .musicPlayer:
            return Text("Music player button")
        }
    }

    func getImage() -> Image {
        switch self {
        case .info:
            return Image(systemName: "info.circle")
        case .share:
            return Image(systemName: "square.and.arrow.up")
        case .textSize:
            return Image(systemName: "textformat.size")
        case .tags:
            return Image(systemName: "tag")
        case .tune:
            return Image(systemName: "music.note")
        case .musicPlayer:
            return Image(systemName: "play")
        }
    }
}
