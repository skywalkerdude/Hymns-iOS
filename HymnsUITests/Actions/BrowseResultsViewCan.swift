import Foundation
import XCTest

public class BrowseResultsViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func goBackToBrowse() -> BrowseViewCan {
        app.buttons["Go back"].tap()
        return BrowseViewCan(app, testCase: testCase)
    }

    public func tapResult(_ result: String) -> DisplayHymnViewCan {
        app.buttons[result].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }
}
