import Quick
import Nimble
@testable import Hymns

class ConverterSpec: QuickSpec {

    // Don't worry about force_try in tests.
    // swiftlint:disable force_try
    override func spec() {
        describe("using an in-memory database queue") {
            var target: Converter!
            beforeEach {
                target = ConverterImpl()
            }
            describe("toHymnEntity") {
                context("valid hymn") {
                    it("should valid hymn entity") {
                        expect(try! target.toHymnEntity(hymnIdentifier: children24, hymn: children_24_hymn)).to(equal(children_24_hymn_entity))
                    }
                }
            }
            describe("toUiHymn") {
                context("nil entity") {
                    it("should return nil") {
                        expect(try! target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: nil)).to(beNil())
                    }
                }
                context("nil lyrics") {
                    let nilLyrics = HymnEntity(hymnIdentifier: classic1151)
                    it("should throw type conversion error") {
                        expect {
                            try target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: nilLyrics)
                        }.to(throwError { (error: TypeConversionError) in
                            expect(error.triggeringError).to(matchError(ErrorType.parsing(description: "lyrics json was empty")))
                        })
                    }
                }
                context("empty lyrics") {
                    let nilLyrics = HymnEntity(hymnIdentifier: classic1151, lyricsJson: "")
                    it("should throw type conversion error") {
                        expect {
                            try target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: nilLyrics)
                        }.to(throwError { (error: TypeConversionError) in
                            expect(error.triggeringError).to(matchError(ErrorType.parsing(description: "lyrics json was empty")))
                        })
                    }
                }
                context("nil title") {
                    let nilTitle = HymnEntity(hymnIdentifier: classic1151, lyricsJson: "[{\"verse_type\":\"verse\",\"verse_content\":[\"line 1\",\"line 2\"]}]")
                    it("should throw type conversion error") {
                        expect {
                            try target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: nilTitle)
                        }.to(throwError { (error: TypeConversionError) in
                            expect(error.triggeringError).to(matchError(ErrorType.parsing(description: "title was empty")))
                        })
                    }
                }
                context("empty title") {
                    let nilTitle = HymnEntity(hymnIdentifier: classic1151, title: "", lyricsJson: "[{\"verse_type\":\"verse\",\"verse_content\":[\"line 1\",\"line 2\"]}]")
                    it("should throw type conversion error") {
                        expect {
                            try target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: nilTitle)
                        }.to(throwError { (error: TypeConversionError) in
                            expect(error.triggeringError).to(matchError(ErrorType.parsing(description: "title was empty")))
                        })
                    }
                }
                context("invalid json") {
                    let invalidJson = HymnEntity(hymnIdentifier: classic1151, title: "title", lyricsJson: "invalid json")
                    it("should throw type conversion error") {
                        expect {
                            try target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: invalidJson)
                        }.to(throwError { (error: TypeConversionError) in
                            expect(error.triggeringError).to(matchError(Swift.DecodingError.self))
                        })
                    }
                }
                // <TypeConversionError(triggeringError: Swift.DecodingError.dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "The given data was not valid JSON.", underlyingError: Optional(Error Domain=NSCocoaErrorDomain Code=3840 "Invalid value around character 0." UserInfo={NSDebugDescription=Invalid value around character 0.}))))>
                context("filled hymn") {
                    let filledHymn = HymnEntity(hymnIdentifier: classic1151, title: "title", lyricsJson: "[{\"verse_type\":\"verse\",\"verse_content\":[\"line 1\",\"line 2\"]}]")
                    let expected = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse(verseType: .verse, verseContent: ["line 1", "line 2"])])
                    it("should throw type conversion error") {
                        expect(try! target.toUiHymn(hymnIdentifier: classic1151, hymnEntity: filledHymn)).to(equal(expected))
                    }
                }
            }
        }
    }
}
