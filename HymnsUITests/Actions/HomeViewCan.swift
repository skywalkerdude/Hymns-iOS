import Foundation
import XCTest

public struct HomeViewCan {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(_ app: XCUIApplication, testCase: XCTestCase) {
        self.app = app
        self.testCase = testCase
    }

    public func activateSearch() -> HomeViewCan {
        app.textFields.element.tap()
        return self
    }

    public func performSearch(searchParameter: String) -> HomeViewCan {
        app.textFields.element.typeText(searchParameter)
        return self
    }

    public func tapResult(result: String) -> DisplayHymnViewCan {
        app.buttons[result].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }
}
