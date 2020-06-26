import XCTest

class BaseTestCase: XCTestCase {

    static let uiTestingFlag = "-UITests"

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false // in UI tests it is usually best to stop immediately when a failure occurs
        app = XCUIApplication()
        app.launchArguments.append(BaseTestCase.uiTestingFlag)
        app.launch()
    }
}
