import Foundation
import XCTest

/**
 * Base calss for all the *Can classes.
 */
public class BaseViewCan {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(_ app: XCUIApplication, testCase: XCTestCase) {
        self.app = app
        self.testCase = testCase
    }

    public func waitUntilDisplayed(_ strings: String...) -> Self {
        for string in strings {
            _ = app.staticTexts[string].waitForExistence(timeout: 2)
        }
        return self
    }

    public func takeScreenshot(name: String) -> Self {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        testCase.add(attachment)
        return self
    }
}
