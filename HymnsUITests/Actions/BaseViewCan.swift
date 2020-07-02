import Foundation
import SnapshotTesting
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

    public func waitForButtons(_ strings: String...) -> Self {
        for string in strings {
            XCTAssertTrue(app.buttons[string].waitForExistence(timeout: 2))
        }
        return self
    }

    public func waitForStaticTexts(_ strings: String...) -> Self {
        for string in strings {
            XCTAssertTrue(app.staticTexts[string].waitForExistence(timeout: 2))
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

    public func checkScreenshot() -> Self {
        sleep(5)
        let screenshot = app.screenshot()
        // Need precision to be 80% because of potential diffs in battery life, time, and wifi signal influencing the
        // screenshots.
        assertSnapshot(matching: screenshot.image, as: .image(precision: 0.7))
        return self
    }
}

extension XCUIElement {
    /**
     * Removes any current text in the field before typing in the new value
     * - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
