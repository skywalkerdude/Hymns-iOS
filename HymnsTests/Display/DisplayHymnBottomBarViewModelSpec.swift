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
            }

            describe("init") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, backgroundQueue: testQueue)
                }
                it("should set up the info dialog") {
                    expect(target.songInfo).to(equal(SongInfoDialogViewModel(hymnToDisplay: classic1151)))
                }
                it("shareable lyrics should be an empty string") {
                    expect(target.shareableLyrics).to(equal(""))
                }
            }

            context("with valid repository and hymn 1151") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, backgroundQueue: testQueue)
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                        Just(nil).assertNoFailure().eraseToAnyPublisher()
                    }
                }
                describe("performing fetch") {
                    beforeEach {
                        target.fetchLyrics()
                        testQueue.sync {}
                        testQueue.sync {}
                        testQueue.sync {}
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                    it("should set up the info dialog") {
                        expect(target.songInfo).to(equal(SongInfoDialogViewModel(hymnToDisplay: classic1151)))
                    }
                    it("shareable lyrics should be an empty string") {
                        expect(target.shareableLyrics).to(equal(""))
                    }
                }
            }

            context("fetch hymn 1151 with valid repository") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, backgroundQueue: testQueue)
                    let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse](), pdfSheet: Hymns.MetaDatum(name: "Lead Sheet", data: [Hymns.Datum(value: "Piano", path: "/en/hymn/c/1151/f=ppdf"), Hymns.Datum(value: "Guitar", path: "/en/hymn/c/1151/f=pdf"), Hymns.Datum(value: "Text", path: "/en/hymn/c/1151/f=gtpdf")]))
                    given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                        Just(hymn).assertNoFailure().eraseToAnyPublisher()
                    }
                }
                describe("performing fetch") {
                    beforeEach {
                        target.fetchLyrics()
                        testQueue.sync {}
                        testQueue.sync {}
                        testQueue.sync {}
                    }
                    it("should call hymnsRepository.getHymn") {
                        verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                    }
                    it("should set up the info dialog") {
                        expect(target.songInfo).to(equal(SongInfoDialogViewModel(hymnToDisplay: classic1151)))
                    }
                    it("shareable lyrics should be an empty string") {
                        expect(target.shareableLyrics).to(equal(""))
                    }
                }
            }
        }
    }
}
