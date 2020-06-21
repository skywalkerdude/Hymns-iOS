import XCTest

class HymnsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
        // We send a command line argument to our app,
        // to enable it to reset its state. Useful to remove flakiness
        app.launchArguments.append("--uitesting")
    }

    func ignore_test_navigateBetweenTabs() {
        app.launch()
        let tabBarsQuery = app.tabBars
        let tab1 = tabBarsQuery.children(matching: .button).element(boundBy: 0) //Home
        let tab2 = tabBarsQuery.children(matching: .button).element(boundBy: 1) //Browse
        let tab3 = tabBarsQuery.children(matching: .button).element(boundBy: 2) //Favorites
        let tab4 = tabBarsQuery.children(matching: .button).element(boundBy: 3) //Settings

        //TODO: Assertions after each tap
        tab1.tap()
        tab4.tap() //Settings
        tab3.tap()
        tab2.tap()
        tab1.tap()
        tab2.tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
