import Foundation
import XCTest

public class HomeViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func activateSearch() -> HomeViewCan {
        app.textFields.element.tap()
        return self
    }

    public func performSearch(_ searchParameter: String) -> HomeViewCan {
        app.textFields.element.typeText(searchParameter)
        return self
    }

    public func tapResult(_ result: String) -> DisplayHymnViewCan {
        app.buttons[result].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }
}
