import XCTest

class DisplayHymnScenarios: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false // in UI tests it is usually best to stop immediately when a failure occurs
        app = XCUIApplication()
        app.launchArguments.append("-UITests")
        app.launch()
    }
    
    func test_goToSongFromSearch() {
        _ = HomeViewCan(app, testCase: self)
            .activateSearch()
            .performSearch("1151")
            .tapResult("Hymn 1151")
            .waitUntilDisplayed("verse 1 line 1")
    }

    func test_goToSongFromRecents() {
        _ = HomeViewCan(app, testCase: self)
            .waitUntilDisplayed("classic1151", "classic40", "classic2", "classic")
            .tapResult("classic1151")
            .waitUntilDisplayed("verse 1 line 1")
    }
}
