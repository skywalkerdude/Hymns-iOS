import XCTest

class BrowseScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_browseTags() {
        _ = HomeViewCan(app, testCase: self)
            .goToBrowse()
            .goToTags()
            .waitForButtons("tag1", "tag2")
            .tapTag("tag1")
            .waitForButtons("Click me!", "Don't click me!", timeout: 3)
            .tapResult("Click me!")
            .waitForStaticTexts("verse 1 line 1")
//            .goBackToBrowseResults()
//            .waitForButtons("Click me!", "Don't click me!", timeout: 3)
//            .goBackToBrowse()
//            .waitForButtons("tag1", "tag2")
    }

    func test_browseCategory() {
        _ = HomeViewCan(app, testCase: self)
            .goToBrowse()
            .assertCategory("category 1", chevronUp: false)
            .assertCategory("category 2", chevronUp: false)
            .tapCategory("category 1")
            .assertCategory("category 1", chevronUp: true)
            .assertCategory("category 2", chevronUp: false)
            .assertSubcategory(category: "category 1", subcategory: "All subcategories", count: 6)
            .assertSubcategory(category: "category 1", subcategory: "subcategory 1", count: 5)
            .assertSubcategory(category: "category 1", subcategory: "subcategory 2", count: 1)
            .tapSubcategory("subcategory 2", count: 1)
            .waitForButtons("Click me!", "Don't click!", "Don't click either!")
            .tapResult("Click me!")
            .waitForStaticTexts("verse 1 line 1")
//            .goBackToBrowseResults()
//            .waitForButtons("Click me!", "Don't click!", "Don't click either!")
//            .goBackToBrowse()
//            .assertCategory("category 1", chevronUp: true)
//            .assertCategory("category 2", chevronUp: false)
//            .assertSubcategory(category: "category 1", subcategory: "All subcategories", count: 6)
//            .assertSubcategory(category: "category 1", subcategory: "subcategory 1", count: 5)
//            .assertSubcategory(category: "category 1", subcategory: "subcategory 2", count: 1)
    }

    func test_browseScriptures() {
        _ = HomeViewCan(app, testCase: self)
            .goToBrowse()
            .goToScriptureSongs()
            .assertCategory("Genesis", chevronUp: false)
            .assertCategory("Hosea", chevronUp: false)
            .assertCategory("Revelation", chevronUp: false)
            .tapBook("Revelation")
            .assertCategory("Genesis", chevronUp: false)
            .assertCategory("Hosea", chevronUp: false)
            .assertCategory("Revelation", chevronUp: true)
            .waitForButtons("General\nDon't click me!", "22\nClick me!")
            .tapReference("22\nClick me!")
            .waitForStaticTexts("verse 1 line 1")
//            .goBackToBrowse()
//            .assertCategory("Genesis", chevronUp: false)
//            .assertCategory("Hosea", chevronUp: false)
//            .assertCategory("Revelation", chevronUp: true)
//            .waitForButtons("General\nDon't click me!", "22\nClick me!")
    }

    func test_browseAllSongs() {
        _ = HomeViewCan(app, testCase: self)
            .goToBrowse()
            .goToAllSongs()
            .waitForButtons("Classic hymns", "New songs", "Children's songs", "Howard Higashi songs")
            .tapHymnType("Classic hymns")
            .waitForButtons("1. Title of Hymn 1", "2. Title of Hymn 2", "3. Title of Hymn 3", timeout: 3)
            .tapResult("2. Title of Hymn 2")
            .waitForStaticTexts("classic hymn 2 lyrics")
//            .goBackToBrowseResults()
//            .waitForButtons("1. Title of Hymn 1", "2. Title of Hymn 2", "3. Title of Hymn 3", timeout: 3)
//            .goBackToBrowse()
//            .waitForButtons("Classic hymns", "New songs", "Children's songs", "Howard Higashi songs")
    }
}
