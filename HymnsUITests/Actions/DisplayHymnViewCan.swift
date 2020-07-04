import Foundation
import XCTest

public class DisplayHymnViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func openShareSheet() -> DisplayHymnViewCan {
        return pressButton("square.and.arrow.up")
    }

    public func openFontPicker() -> DisplayHymnViewCan {
        return pressButton("textformat.size")
    }

    public func openLanguages() -> DisplayHymnViewCan {
        return pressButton("globe")
    }

    public func openTagSheet() -> DisplayHymnViewCan {
        return pressButton("tag")
    }

    public func openRelevant() -> DisplayHymnViewCan {
        return pressButton("music.note.list")
    }

    public func openSongInfo() -> DisplayHymnViewCan {
        return pressButton("info.circle")
    }

    public func pressCancel() -> DisplayHymnViewCan {
        return pressButton("Cancel")
    }
}
