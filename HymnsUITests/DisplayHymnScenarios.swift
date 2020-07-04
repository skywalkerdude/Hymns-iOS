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

    func test_tagSheet() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openTagSheet()
            .waitForStaticTexts("Name your tag")
    }

    func test_songInfoDialog() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openSongInfo()
            .waitForStaticTexts("Category", "song's category", "Subcategory", "song's subcategory")
    }

    func test_changeFontSize() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openFontPicker()
            .waitForButtons("Normal")
    }
}
