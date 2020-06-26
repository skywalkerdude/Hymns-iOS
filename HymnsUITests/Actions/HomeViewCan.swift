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

    public func tapHome() -> HomeViewCan {
        app.tabBars.children(matching: .button).element(boundBy: 0).tap()
        return self
    }

    public func verifyHomeTab() -> HomeViewCan {
        XCTAssertTrue(app.staticTexts["Look up any hymn"].exists)
        return self
    }

    public func tapBrowse() -> HomeViewCan {
        app.tabBars.children(matching: .button).element(boundBy: 1).tap()
        return self
    }

    public func verifyBrowseTab() -> HomeViewCan {
        XCTAssertTrue(app.staticTexts["Browse"].exists)
        return self
    }

    public func tapFavorites() -> HomeViewCan {
        app.tabBars.children(matching: .button).element(boundBy: 2).tap()
        return self
    }

    public func verifyFavoritesTab() -> HomeViewCan {
        XCTAssertTrue(app.staticTexts["Favorites"].exists)
        return self
    }

    public func tapSettings() -> HomeViewCan {
        app.tabBars.children(matching: .button).element(boundBy: 3).tap()
        return self
    }

    public func verifySettingsTab() -> HomeViewCan {
        XCTAssertTrue(app.staticTexts["Settings"].exists)
        return self
    }
}
