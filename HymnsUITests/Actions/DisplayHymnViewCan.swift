import Foundation
import XCTest

public class DisplayHymnViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func openShareSheet() -> DisplayHymnViewCan {
        return pressButton("Share lyrics")
    }

    public func openFontPicker() -> DisplayHymnViewCan {
        return pressButton("Change lyrics font size")
    }

    public func openLanguages() -> DisplayHymnViewCan {
        return pressButton("Show languages")
    }

    public func openAudioPlayer() -> DisplayHymnViewCan {
        return pressButton("Play music")
    }

    public func openRelevant() -> DisplayHymnViewCan {
        return pressButton("Relevant songs")
    }

    public func openTagSheet() -> DisplayHymnViewCan {
        return pressButton("Tags")
    }

    public func openSongInfo() -> DisplayHymnViewCan {
        return pressButton("Song Info")
    }

    public func openOverflowMenu() -> DisplayHymnViewCan {
        return pressButton("More options")
    }

    public func pressCancel() -> DisplayHymnViewCan {
        return pressButton("Cancel")
    }
}
