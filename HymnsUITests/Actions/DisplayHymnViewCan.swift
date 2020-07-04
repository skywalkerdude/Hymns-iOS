import Foundation
import XCTest

public class DisplayHymnViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func openShareSheet() -> DisplayHymnViewCan {
        app.buttons["square.and.arrow.up"].tap()
        return self
    }

    public func openFontPicker() -> DisplayHymnViewCan {
        app.buttons["textformat.size"].tap()
        return self
    }

    public func openTagSheet() -> DisplayHymnViewCan {
        app.buttons["tag"].tap()
        return self
    }

    public func openSongInfo() -> DisplayHymnViewCan {
        app.buttons["info.circle"].tap()
        return self
    }
}
