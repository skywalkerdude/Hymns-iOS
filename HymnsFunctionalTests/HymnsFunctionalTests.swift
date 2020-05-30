import XCTest
import EarlGrey
@testable import Hymns

class EarlGreyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //Make sure earl grey is working and we have the views in the window
    func testPresenceOfKeyWindow() {
        EarlGrey.selectElement(with: grey_keyWindow())
            .assert(grey_sufficientlyVisible())
    }

    //Tests that a hymn can be search and asserts it is visible after the search
    func testSearchForHymn() throws {
        EarlGrey.selectElement(with: grey_accessibilityValue("Search by numbers or words"))
            .perform(grey_tap())
            .perform(grey_replaceText("1151"))
        EarlGrey.selectElement(with: grey_accessibilityLabel("Hymn 1151"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Drink! A river pure and clear that’s flowing from the throne;"))
            .assert(grey_sufficientlyVisible())
            .usingSearch(grey_scrollInDirection(GREYDirection.down, 900), onElementWith: grey_accessibilityLabel("Where the brothers all unite and truly are one."))
            .assert(grey_sufficientlyVisible())
        EarlGrey.selectElement(with: grey_accessibilityLabel("chevron.left"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Cancel"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Look up any hymn"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
    }
}

//TODO: Find a way to reset the app after each test as mentioned at https://github.com/google/EarlGrey/blob/master/docs/faq.md then we can combine all the tests in one class.
class EarlGreyUITests2: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //Tests that a hymn can be search and asserts it is visible after the search
    func testTabbingMusic() throws {
        EarlGrey.selectElement(with: grey_accessibilityValue("Search by numbers or words"))
            .perform(grey_tap())
            .perform(grey_replaceText("1151"))
        EarlGrey.selectElement(with: grey_accessibilityLabel("Hymn 1151"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Guitar"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Piano"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Lyrics"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
        EarlGrey.selectElement(with: grey_accessibilityLabel("Chords"))
            .assert(grey_sufficientlyVisible())
            .perform(grey_tap())
    }
}

