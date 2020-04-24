import Combine
import Mockingbird
import Nimble
import Quick
@testable import Hymns

class HomeViewModelSpec: QuickSpec {

    override func spec() {
        describe("HymnLyricsViewModel") {
            // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
            let testQueue = DispatchQueue(label: "test_queue")
            var historyStore: HistoryStoreMock!
            var songResultsRepository: SongResultsRepositoryMock!
            var target: HomeViewModel!

            let recentSongs = [RecentSong(hymnIdentifier: classic1151, songTitle: "Hymn 1151"),
                               RecentSong(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014")]
            beforeEach {
                historyStore = mock(HistoryStore.self)
                given(historyStore.recentSongs(onChanged: any())) ~> { onChanged in
                    onChanged(recentSongs)
                    return mock(Notification.self)
                }
                songResultsRepository = mock(SongResultsRepository.self)
                target = HomeViewModel(backgroundQueue: testQueue, historyStore: historyStore, mainQueue: testQueue, repository: songResultsRepository)
            }
            context("default state") {
                beforeEach {
                    sleep(1) // all time for the debouncer to trigger.
                }
                let recentHymns = "Recent hymns"
                it("\"\(recentHymns)\" label should be showing") {
                    expect(target.label).toEventuallyNot(beNil())
                    expect(target.label).to(equal(recentHymns))
                }
                it("should fetch the recent songs from the history store") {
                    verify(historyStore.recentSongs(onChanged: any())).wasCalled(exactly(1))
                }
                it("should display recent songs") {
                    expect(target.songResults).toEventually(haveCount(2))
                    expect(target.songResults[0].title).to(equal(recentSongs[0].songTitle))
                    expect(target.songResults[1].title).to(equal(recentSongs[1].songTitle))
                }
            }
            context("search active") {
                beforeEach {
                    testQueue.sync {
                        target.searchActive = true
                    }
                }
                context("empty search parameter") {
                    let recentSearches = "Recent searches"
                    it("\"\(recentSearches)\" label should be showing") {
                        expect(target.label).toEventuallyNot(beNil())
                        expect(target.label).toEventually(equal(recentSearches))
                    }
                    it("should display recent searches") {
                        expect(target.songResults).toEventually(equal([PreviewSongResults.joyUnspeakable, PreviewSongResults.sinfulPast]))
                    }
                }
                let searchParameter = "Wakanda Forever"
                context("with search parameter: \(searchParameter)") {
                    context("with network error") {
                        beforeEach {
                            given(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)) ~> {                                Just(nil).eraseToAnyPublisher()
                            }
                            testQueue.sync {
                                target.searchParameter = searchParameter
                            }
                            sleep(1) // all time for the debouncer to trigger.
                        }
                        it("no label should be showing") {
                            expect(target.label).to(beNil())
                        }
                        it("song results should be empty") {
                            expect(target.songResults).to(beEmpty())
                        }
                        it("should call songResultsRepository.search") {
                            verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)).wasCalled(exactly(1))
                        }
                    }
                    context("with network search") {
                        let classic594 = SongResult(name: "classic594", path: "/en/hymn/h/594?gb=1&query=3")
                        let noHymnType = SongResult(name: "noHymnType", path: "")
                        let newTune7 = SongResult(name: "newTune7", path: "/en/hymn/nt/7")
                        let noHymnNumber = SongResult(name: "noHymnNumber", path: "/en/hymn/h/a")
                        let songResultsPage = SongResultsPage(results: [classic594, noHymnType, newTune7, noHymnNumber], hasMorePages: true)
                        beforeEach {
                            given(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)) ~> { searchInput, pageNumber in
                                return Just(songResultsPage).eraseToAnyPublisher()
                            }
                            testQueue.sync {
                                target.searchParameter = searchParameter
                            }
                            sleep(1) // all time for the debouncer to trigger.
                        }
                        it("no label should be showing") {
                            expect(target.label).to(beNil())
                        }
                        it("should have two results") {
                            expect(target.songResults).toEventually(haveCount(2))
                            expect(target.songResults[0].title).to(equal("classic594"))
                            expect(target.songResults[1].title).to(equal("newTune7"))
                        }
                        it("should call songResultsRepository.search") {
                            verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)).wasCalled(exactly(1))
                        }
                    }
                }
            }
        }
    }
}
