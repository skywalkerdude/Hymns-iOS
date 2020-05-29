import Quick
import Nimble
import Mockingbird
import Combine
@testable import Hymns

// swiftlint:disable:next type_name
class DisplayHymnBottomBarViewModelSpec: QuickSpec {

    override func spec() {
        describe("DisplayHymnBottomBarViewModel") {
            let testQueue = DispatchQueue(label: "test_queue")
            var hymnsRepository: HymnsRepositoryMock!
            var target: DisplayHymnBottomBarViewModel!

            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
                target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, backgroundQueue: testQueue)
            }
            describe("init") {
                it("should set up the info dialog") {
                    expect(target.songInfo).to(equal(SongInfoDialogViewModel(hymnToDisplay: classic1151)))
                }
                it("shareable lyrics should be an empty string") {
                    expect(target.shareableLyrics).to(equal(""))
                }
                it("languages should be empty") {
                    expect(target.languages).to(beEmpty())
                }
                it("mp3Path should be nil") {
                    expect(target.mp3Path).to(beNil())
                }
            }
            context("with nil repository result") {
                beforeEach {
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                        Just(nil).assertNoFailure().eraseToAnyPublisher()
                    }

                    target.fetchHymn()
                    testQueue.sync {}
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("should call hymnsRepository.getHymn") {
                    verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                }
                it("shareable lyrics should be an empty string") {
                    expect(target.shareableLyrics).to(equal(""))
                }
                it("languages should be empty") {
                    expect(target.languages).to(beEmpty())
                }
            }
            context("with empty repository result") {
                beforeEach {
                    let emptyLyrics = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse]())
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                        Just(emptyLyrics).assertNoFailure().eraseToAnyPublisher()
                    }

                    target.fetchHymn()
                    testQueue.sync {}
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("should call hymnsRepository.getHymn") {
                    verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                }
                it("shareable lyrics should be an empty string") {
                    expect(target.shareableLyrics).to(equal(""))
                }
                it("languages should be empty") {
                    expect(target.languages).to(beEmpty())
                }
                it("mp3Path should be nil") {
                    expect(target.mp3Path).to(beNil())
                }
            }
            context("with valid repository result") {
                beforeEach {
                    let lyricsWithoutTransliteration = [
                        Verse(verseType: .verse, verseContent: ["Drink! a river pure and clear that's flowing from the throne;", "Eat! the tree of life with fruits abundant, richly grown"], transliteration: nil),
                        Verse(verseType: .chorus, verseContent: ["Do come, oh, do come,", "Says Spirit and the Bride:"], transliteration: nil)
                    ]
                    let languages = MetaDatum(name: "lang", data: [Datum(value: "Tagalog", path: "/en/hymn/ht/1151"),
                                                                   Datum(value: "Missing path", path: ""),
                                                                   Datum(value: "Invalid number", path: "/en/hymn/h/13f/f=333/asdf"),
                                                                   Datum(value: "诗歌(简)", path: "/en/hymn/ts/216?gb=1")])
                    let music = MetaDatum(name: "music", data: [Datum(value: "mp3", path: "/en/hymn/h/1151/f=mp3")])
                    let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: lyricsWithoutTransliteration, languages: languages, music: music)
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                        Just(hymn).assertNoFailure().eraseToAnyPublisher()
                    }

                    target.fetchHymn()
                    testQueue.sync {}
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("should call hymnsRepository.getHymn") {
                    verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                }
                it("shareable lyrics should be Drink a river") {
                    expect(target.shareableLyrics).to(equal("Drink! a river pure and clear that's flowing from the throne;\nEat! the tree of life with fruits abundant, richly grown\n\nDo come, oh, do come,\nSays Spirit and the Bride:\n\n"))
                }
                it("languages should have two items") {
                    expect(target.languages).to(haveCount(2))
                    expect(target.languages[0].title).to(equal("Tagalog"))
                    expect(target.languages[1].title).to(equal("诗歌(简)"))
                }
                let mp3FilePath = URL(string: "http://www.hymnal.net/en/hymn/h/1151/f=mp3")
                it("mp3Path should be \(String(describing: mp3FilePath))") {
                    expect(target.mp3Path).to(equal(mp3FilePath))
                }
            }
        }
    }
}
