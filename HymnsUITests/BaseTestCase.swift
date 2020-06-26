import XCTest

class BaseTestCase: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false // in UI tests it is usually best to stop immediately when a failure occurs
        app = XCUIApplication()
        app.launchArguments.append("-UITests")
        app.launch()
    }
}
