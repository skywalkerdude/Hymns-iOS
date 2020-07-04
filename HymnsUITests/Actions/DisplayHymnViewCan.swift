import Foundation
import SnapshotTesting
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

    public func checkFontPickerScreenshot() -> DisplayHymnViewCan {
        sleep(5)
        let screenshot = app.screenshot()
        // Need precision to be 80% because of potential diffs in battery life, time, and wifi signal influencing the
        // screenshots.
        assertSnapshot(matching: screenshot.image, as: .image(precision: 0.7))
        return self
    }

    public func openTagSheet() -> DisplayHymnViewCan {
        app.buttons["tag"].tap()
        return self
    }
}
