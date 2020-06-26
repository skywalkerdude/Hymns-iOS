import XCTest

class DisplayHymnScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_goToSongFromRecentSongs() {
        _ = HomeViewCan(app, testCase: self)
            .waitUntilDisplayed("classic1151", "classic40", "classic2", "classic")
            .tapResult("classic1151")
            .waitUntilDisplayed("verse 1 line 1")
    }

    func test_goToSongFromNumber() {
        _ = HomeViewCan(app, testCase: self)
            .activateSearch()
            .typeSearchText("1151")
            .tapResult("Hymn 1151")
            .waitUntilDisplayed("verse 1 line 1")
    }

    func test_goToSongFromSearchResults() {
        _ = HomeViewCan(app, testCase: self)
            .activateSearch()
            .typeSearchText("search param")
            .tapResult("Click me!")
            .waitUntilDisplayed("verse 1 line 1")
    }
}
