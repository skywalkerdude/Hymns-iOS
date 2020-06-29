import XCTest

class DisplayHymnScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_goToSongFromRecentSongs() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .waitForStaticTexts("verse 1 line 1")
    }

    func test_goToSongFromNumber() {
        _ = HomeViewCan(app, testCase: self)
            .activateSearch()
            .waitForButtons("Cancel")
            .typeSearchText("1151")
            .waitForButtons("Hymn 1151")
            .tapResult("Hymn 1151")
            .waitForStaticTexts("verse 1 line 1")
    }

    func test_goToSongFromSearchResults() {
        _ = HomeViewCan(app, testCase: self)
            .activateSearch()
            .typeSearchText("search param")
            .waitForButtons("Click me!")
            .tapResult("Click me!")
            .waitForStaticTexts("verse 1 line 1")
    }
}
