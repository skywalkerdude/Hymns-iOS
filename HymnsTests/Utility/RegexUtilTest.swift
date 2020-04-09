import XCTest
@testable import Hymns

class RegexUtilTest: XCTestCase {

    func test_getHymnType() {
        let classic = "/en/hymn/h/594"
        XCTAssertEqual(HymnType.classic, RegexUtil.getHymnType(path: classic))

        let newTune = "/en/hymn/nt/594"
        XCTAssertEqual(HymnType.newTune, RegexUtil.getHymnType(path: newTune))

        let newSong = "/en/hymn/ns/594"
        XCTAssertEqual(HymnType.newSong, RegexUtil.getHymnType(path: newSong))

        let children = "/en/hymn/c/594"
        XCTAssertEqual(HymnType.children, RegexUtil.getHymnType(path: children))

        let longBeach = "/en/hymn/lb/594"
        XCTAssertEqual(HymnType.howardHigashi, RegexUtil.getHymnType(path: longBeach))

        let letterBefore = "/en/hymn/h/c333"
        XCTAssertEqual(HymnType.classic, RegexUtil.getHymnType(path: letterBefore))

        let letterBeforeAndAfter = "/en/hymn/h/c333f"
        XCTAssertEqual(HymnType.classic, RegexUtil.getHymnType(path: letterBeforeAndAfter))

        let letterAfter = "/en/hymn/h/13f"
        XCTAssertEqual(HymnType.classic, RegexUtil.getHymnType(path: letterAfter))

        let noMatch = ""
        XCTAssertNil(RegexUtil.getHymnType(path: noMatch))

        let manyLetters = "/en/hymn/h/13fasdf"
        XCTAssertEqual(HymnType.classic, RegexUtil.getHymnType(path: manyLetters))

        let queryParams = "/en/hymn/h/594?gb=1&query=3"
        XCTAssertEqual(HymnType.classic, RegexUtil.getHymnType(path: queryParams))
    }

    func test_getHymnNumber() {
        let classic = "/en/hymn/h/594"
        XCTAssertEqual("594", RegexUtil.getHymnNumber(path: classic))

        let letterBefore = "/en/hymn/h/c333"
        XCTAssertEqual("c333", RegexUtil.getHymnNumber(path: letterBefore))

        let letterBeforeAndAfter = "/en/hymn/h/c333f"
        XCTAssertEqual("c333f", RegexUtil.getHymnNumber(path: letterBeforeAndAfter))

        let letterAfter = "/en/hymn/h/13f"
        XCTAssertEqual("13f", RegexUtil.getHymnNumber(path: letterAfter))

        let noMatch = ""
        XCTAssertNil(RegexUtil.getHymnNumber(path: noMatch))

        let manyLetters = "/en/hymn/h/13fasdf"
        XCTAssertEqual("13fasdf", RegexUtil.getHymnNumber(path: manyLetters))

        let chordPdf = "/en/hymn/h/13f/f=pdf"
        XCTAssertEqual("13f", RegexUtil.getHymnNumber(path: chordPdf))

        let guitarPdf = "/en/hymn/h/13f/f=pdf"
        XCTAssertEqual("13f", RegexUtil.getHymnNumber(path: guitarPdf))

        let mp3 = "/en/hymn/h/13f/f=mp3"
        XCTAssertEqual("13f", RegexUtil.getHymnNumber(path: mp3))

        let manyLettersPdf = "/en/hymn/h/13fasdf/f=pdf"
        XCTAssertEqual("13fasdf", RegexUtil.getHymnNumber(path: manyLettersPdf))

        let lettersAfter = "/en/hymn/h/13f/f=333/asdf"
        XCTAssertNil(RegexUtil.getHymnNumber(path: lettersAfter))

        let noNumber = "/en/hymn/h/a"
        XCTAssertNil(RegexUtil.getHymnNumber(path: noNumber))

        let queryParams = "/en/hymn/h/594?gb=1&query=3"
        XCTAssertEqual("594", RegexUtil.getHymnNumber(path: queryParams))
    }
}
