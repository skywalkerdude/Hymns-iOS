import XCTest

class SettingsScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_clearHistory() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151")
            .goToSettings()
            .tapClearHistory()
            .waitForStaticTexts("Recent songs cleared")
            .returnToHome()
            .tapHome()
            .verifyButtonsNotExist("classic1151")
    }

    func test_goToAboutUs() {
        _ = HomeViewCan(app, testCase: self)
            .goToSettings()
            .tapAboutUs()
            .verifyAboutUsDialogExists()
            .cancelAboutUs()
            .verifyAboutUsDialogNotExists()
    }
}
