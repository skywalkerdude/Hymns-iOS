import XCTest

class DisplayHymnScenarios: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false // in UI tests it is usually best to stop immediately when a failure occurs
        app = XCUIApplication()
        app.launchArguments.append("-UITests")
        app.launch()
    }
    
    func test_goToSong() {
        _ = HomeViewCan(app, testCase: self)
            .activateSearch()
            .performSearch(searchParameter: "1151")
            .tapResult(result: "Hymn 1151")
            .waitUntilDisplayed(title: "Hymn 1151")
    }
}
