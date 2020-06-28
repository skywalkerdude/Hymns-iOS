import XCTest

class SettingsScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
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
