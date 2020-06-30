import Foundation
import XCTest

public class DisplayHymnViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func openShareSheet() -> DisplayHymnViewCan {
        app.buttons["square.and.arrow.up"].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }

    public func openFontPicker() -> DisplayHymnViewCan {
        app.buttons["textformat.size"].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }

    public func openTagSheet() -> DisplayHymnViewCan {
        app.buttons["tag"].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }
}
