import SnapshotTesting
import XCTest

class DisplayHymnScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_shareLyrics() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openShareSheet()
            .waitForButtons("Edit Actions…")
    }

    func test_changeFontSize() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openFontPicker()
            .waitForButtons("Normal")
            .checkFontPickerScreenshot()
    }
}
