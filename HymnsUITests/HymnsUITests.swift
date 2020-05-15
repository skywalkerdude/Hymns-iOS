import XCTest

class HymnsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
        // We send a command line argument to our app,
        // to enable it to reset its state. Useful to remove flakiness
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_navigateBetweenTabs() {
        app.launch()
        let tabBarsQuery = app.tabBars
        let homeTab = tabBarsQuery.children(matching: .button).element(boundBy: 0)
        let browseTab = tabBarsQuery.children(matching: .button).element(boundBy: 1)
        let favoritesTab = tabBarsQuery.children(matching: .button).element(boundBy: 2)
        let settingsTab = tabBarsQuery.children(matching: .button).element(boundBy: 3)

        homeTab.tap()
        XCTAssertEqual(app.staticTexts["Recent hymns"].label, "Recent hymns")

        settingsTab.tap()
        XCTAssertEqual(app.staticTexts["Settings"].label, "Settings")

        favoritesTab.tap()
        XCTAssertEqual(app.staticTexts["Favorites"].label, "Favorites")

        browseTab.tap()
        XCTAssertEqual(app.staticTexts["Browse"].label, "Browse")

        homeTab.tap()
        XCTAssertEqual(app.staticTexts["Recent hymns"].label, "Recent hymns")

        settingsTab.tap()
        XCTAssertEqual(app.staticTexts["Settings"].label, "Settings")

    }
    
    func testSearchBarFunctioning() {
        app.launch()
        app.textFields.element.tap()
        app.textFields.element.typeText("test")
        //Note the .keys function will only work if you have your iOS Simulator with hardware keyboard off to use the app's keyboard
        app.keys["t"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        
        app.buttons["Cancel"].tap()
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
