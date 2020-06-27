import Foundation
import XCTest

public class FavoritesViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func tapFavorite(_ favorite: String) -> DisplayHymnViewCan {
        app.buttons[favorite].tap()
        return DisplayHymnViewCan(app, testCase: testCase)
    }
}
