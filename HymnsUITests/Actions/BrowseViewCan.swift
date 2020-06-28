import Foundation
import XCTest

public class BrowseViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func goToTags() -> BrowseViewCan {
        app.buttons["Tags"].tap()
        return self
    }

    public func tapTag(_ tag: String) -> BrowseResultsViewCan {
        app.buttons[tag].tap()
        return BrowseResultsViewCan(app, testCase: testCase)
    }

    public func tapCategory(_ category: String) -> BrowseViewCan {
        app.staticTexts[category].tap()
        return self
    }

    public func assertCategory(_ category: String, chevronUp: Bool) -> BrowseViewCan {
        for index in 0..<app.cells.count {
            let cell = app.cells.element(boundBy: index)
            if cell.descendants(matching: .staticText).element.label == category {
                XCTAssertEqual(cell.descendants(matching: .image).element.label, chevronUp ? "chevron.up" : "chevron.down")
                return self
            }
        }
        testCase.recordFailure(withDescription: "unable to find category \(category) with chevron \(chevronUp ? "up" : "down")", inFile: #file, atLine: #line, expected: false)
        return self
    }

    public func tapSubcategory(_ subcategory: String, count: Int) -> BrowseResultsViewCan {
        app.buttons["\(subcategory)\n\(count)"].tap()
        return BrowseResultsViewCan(app, testCase: testCase)
    }

    public func assertSubcategory(category: String, subcategory: String, count: Int) -> BrowseViewCan {
        for index in 0..<app.cells.count {
            let cell = app.cells.element(boundBy: index)
            for index2 in 0..<cell.descendants(matching: .button).count {
                let button  = cell.descendants(matching: .button).element(boundBy: index2)
                if button.label == "\(subcategory)\n\(count)" {
                    // Found the subcategory
                    return self
                }
            }
        }
        testCase.recordFailure(withDescription: "unable to find subcategory \(subcategory) with count \(count)", inFile: #file, atLine: #line, expected: false)
        return self
    }

    public func goToScriptureSongs() -> BrowseViewCan {
        while !app.buttons["Scripture Songs"].exists {
            app.scrollViews.element.swipeLeft()
        }
        app.buttons["Scripture Songs"].tap()
        return self
    }

    public func tapBook(_ book: String) -> BrowseViewCan {
        app.staticTexts[book].tap()
        return self
    }

    public func assertBook(_ book: String, chevronUp: Bool) -> BrowseViewCan {
        for index in 0..<app.cells.count {
            let cell = app.cells.element(boundBy: index)
            if cell.descendants(matching: .staticText).element.label == book {
                XCTAssertEqual(cell.descendants(matching: .image).element.label, chevronUp ? "chevron.up" : "chevron.down")
                return self
            }
        }
        testCase.recordFailure(withDescription: "unable to find book \(book) with chevron \(chevronUp ? "up" : "down")", inFile: #file, atLine: #line, expected: false)
        return self
    }

    public func tapReference(_ reference: String) -> BrowseResultsViewCan {
        app.buttons["\(reference)"].tap()
        return BrowseResultsViewCan(app, testCase: testCase)
    }
}
