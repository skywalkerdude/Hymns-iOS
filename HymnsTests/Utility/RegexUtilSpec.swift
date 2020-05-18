import Quick
import Nimble
import XCTest
@testable import Hymns

class RegexUtilSpec: QuickSpec {

    override func spec() {
        describe("getting HymnType") {

            let classic = "/en/hymn/h/594"
            context("from \(classic)") {
                it("should be classic") {
                    expect(RegexUtil.getHymnType(path: classic)).to(equal(HymnType.classic))
                }
            }

            let newTune = "/en/hymn/nt/594"
            context("from \(newTune)") {
                it("should be new tune") {
                    expect(RegexUtil.getHymnType(path: newTune)).to(equal(HymnType.newTune))
                }
            }

            let newSong = "/en/hymn/ns/594"
            context("from \(newSong)") {
                it("should be new song") {
                    expect(RegexUtil.getHymnType(path: newSong)).to(equal(HymnType.newSong))
                }
            }

            let children = "/en/hymn/c/594"
            context("from \(children)") {
                it("should be children") {
                    expect(RegexUtil.getHymnType(path: children)).to(equal(HymnType.children))
                }
            }

            let longBeach = "/en/hymn/lb/594"
            context("from \(longBeach)") {
                it("should be long beach") {
                    expect(RegexUtil.getHymnType(path: longBeach)).to(equal(HymnType.howardHigashi))
                }
            }

            let letterBefore = "/en/hymn/h/c333"
            context("from \(letterBefore)") {
                it("should be classic") {
                    expect(RegexUtil.getHymnType(path: letterBefore)).to(equal(HymnType.classic))
                }
            }

            let letterBeforeAndAfter = "/en/hymn/h/c333f"
            context("from \(letterBeforeAndAfter)") {
                it("should be classic") {
                    expect(RegexUtil.getHymnType(path: letterBeforeAndAfter)).to(equal(HymnType.classic))
                }
            }

            let letterAfter = "/en/hymn/h/13f"
            context("from \(letterAfter)") {
                it("should be classic") {
                    expect(RegexUtil.getHymnType(path: letterAfter)).to(equal(HymnType.classic))
                }
            }

            let noMatch = ""
            context("from \(noMatch)") {
                it("should be nil") {
                    expect(RegexUtil.getHymnType(path: noMatch)).to(beNil())
                }
            }

            let manyLetters = "/en/hymn/h/13fasdf"
            context("from \(manyLetters)") {
                it("should be classic") {
                    expect(RegexUtil.getHymnType(path: manyLetters)).to(equal(HymnType.classic))
                }
            }

            let queryParams = "/en/hymn/h/594?gb=1&query=3"
            context("from \(queryParams)") {
                it("should be classic") {
                    expect(RegexUtil.getHymnType(path: queryParams)).to(equal(HymnType.classic))
                }
            }
        }
        describe("getting HymnNumber") {
            let classic = "/en/hymn/h/594"
            context("from \(classic)") {
                it("should be '594'") {
                    expect(RegexUtil.getHymnNumber(path: classic)).to(equal("594"))
                }
            }

            let letterBefore = "/en/hymn/h/c333"
            context("from \(letterBefore)") {
                it("should be 'c333'") {
                    expect(RegexUtil.getHymnNumber(path: letterBefore)).to(equal("c333"))
                }
            }

            let letterBeforeAndAfter = "/en/hymn/h/c333f"
            context("from \(letterBeforeAndAfter)") {
                it("should be 'c333f'") {
                    expect(RegexUtil.getHymnNumber(path: letterBeforeAndAfter)).to(equal("c333f"))
                }
            }

            let letterAfter = "/en/hymn/h/13f"
            context("from \(letterAfter)") {
                it("should be '13f'") {
                    expect(RegexUtil.getHymnNumber(path: letterAfter)).to(equal("13f"))
                }
            }

            let noMatch = ""
            context("from \(noMatch)") {
                it("should be nil") {
                    expect(RegexUtil.getHymnNumber(path: noMatch)).to(beNil())
                }
            }

            let manyLetters = "/en/hymn/h/13fasdf"
            context("from \(manyLetters)") {
                it("should be '13fasdf'") {
                    expect(RegexUtil.getHymnNumber(path: manyLetters)).to(equal("13fasdf"))
                }
            }

            let chordPdf = "/en/hymn/h/13f/f=pdf"
            context("from \(chordPdf)") {
                it("should be '13f'") {
                    expect(RegexUtil.getHymnNumber(path: chordPdf)).to(equal("13f"))
                }
            }

            let guitarPdf = "/en/hymn/h/13f/f=pdf"
            context("from \(guitarPdf)") {
                it("should be '13f'") {
                    expect(RegexUtil.getHymnNumber(path: guitarPdf)).to(equal("13f"))
                }
            }

            let mp3 = "/en/hymn/h/13f/f=mp3"
            context("from \(mp3)") {
                it("should be '13f'") {
                    expect(RegexUtil.getHymnNumber(path: mp3)).to(equal("13f"))
                }
            }

            let manyLettersPdf = "/en/hymn/h/13fasdf/f=pdf"
            context("from \(manyLettersPdf)") {
                it("should be '13fasdf'") {
                    expect(RegexUtil.getHymnNumber(path: manyLettersPdf)).to(equal("13fasdf"))
                }
            }

            let lettersAfter = "/en/hymn/h/13f/f=333/asdf"
            context("from \(lettersAfter)") {
                it("should be nil") {
                    expect(RegexUtil.getHymnNumber(path: lettersAfter)).to(beNil())
                }
            }

            let noNumber = "/en/hymn/h/a"
            context("from \(noNumber)") {
                it("should be nil") {
                    expect(RegexUtil.getHymnNumber(path: noNumber)).to(beNil())
                }
            }

            let queryParams = "/en/hymn/h/594?gb=1&query=3"
            context("from \(queryParams)") {
                it("should be '594'") {
                    expect(RegexUtil.getHymnNumber(path: queryParams)).to(equal("594"))
                }
            }
            describe("geting QueryParams") {
                let emptyString = ""
                context("from \(emptyString)") {
                    it("should be nil") {
                        expect(RegexUtil.getQueryParams(path: emptyString)).to(beNil())
                    }
                }
                let noQueryParams = "/en/hymn/h/594"
                context("from \(noQueryParams)") {
                    it("should be nil") {
                        expect(RegexUtil.getQueryParams(path: noQueryParams)).to(beNil())
                    }
                }
                let oneQueryParam = "/en/hymn/h/594?gb=1"
                context("from \(oneQueryParam)") {
                    it("should be nil") {
                        let queryParams = RegexUtil.getQueryParams(path: oneQueryParam)
                        expect(queryParams).toNot(beNil())
                        expect(queryParams!.count).to(equal(1))
                        expect(queryParams!["gb"]).to(equal("1"))
                    }
                }
                let manyQueryParams = "/en/hymn/h/594?a=b&c=1&gb=89378"
                context("from \(manyQueryParams)") {
                    it("should be have values") {
                        let queryParams = RegexUtil.getQueryParams(path: manyQueryParams)
                        expect(queryParams).toNot(beNil())
                        expect(queryParams!.count).to(equal(3))
                        expect(queryParams!["a"]).to(equal("b"))
                        expect(queryParams!["c"]).to(equal("1"))
                        expect(queryParams!["gb"]).to(equal("89378"))
                    }
                }
            }
        }
    }
}
