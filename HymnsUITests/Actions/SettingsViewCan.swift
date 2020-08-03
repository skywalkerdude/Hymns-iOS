import Foundation
import XCTest

public class SettingsHymnViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func tapAboutUs() -> SettingsHymnViewCan {
        app.buttons["About us"].tap()
        return self
    }

    public func verifyAboutUsDialogExists() -> SettingsHymnViewCan {
        XCTAssertTrue(app.staticTexts["Hello There 👋"].exists)
        return self
    }

    public func cancelAboutUs() -> SettingsHymnViewCan {
        app.buttons["xmark"].tap()
        return self
    }

    public func verifyAboutUsDialogNotExists() -> SettingsHymnViewCan {
        XCTAssertFalse(app.staticTexts["Hello There 👋"].exists)
        return self
    }
}
