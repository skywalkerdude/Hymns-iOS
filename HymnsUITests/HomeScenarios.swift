import XCTest

class HomeScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_switchBetweenTabs() {
        _ = HomeViewCan(app, testCase: self)
            .verifyHomeTab()
            .tapBrowse()
            .verifyBrowseTab()
            .tapFavorites()
            .verifyFavoritesTab()
            .tapSettings()
            .verifySettingsTab()
            .tapHome()
            .verifyHomeTab()
    }

    func test_activateSearch() {
        _ = HomeViewCan(app, testCase: self)
            .verifyCancelNotExists()
            .activateSearch()
            .waitForButtons("Cancel")
            .verifyClearTextNotExists()
            .typeSearchText("1151")
            .verifySearchText("1151")
            .verifyClearTextExists()
            .clearText()
            .verifyClearTextNotExists()
            .verifySearchTextNotExists("1151")
            .cancelSearch()
            .verifyCancelNotExists()
    }

    func test_launchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
