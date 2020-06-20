import Foundation
import XCTest

public struct DisplayHymnViewCan {

    let app: XCUIApplication
    let testCase: XCTestCase

    init(_ app: XCUIApplication, testCase: XCTestCase) {
        self.app = app
        self.testCase = testCase
    }

    public func waitUntilDisplayed(title: String) -> DisplayHymnViewCan {
        _ = app.textFields.element.waitForExistence(timeout: 5)
        return self
    }

    public func takeScreenshot() -> DisplayHymnViewCan {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "Display 1151"
        attachment.lifetime = .keepAlways
        testCase.add(attachment)
        return self
    }
}
