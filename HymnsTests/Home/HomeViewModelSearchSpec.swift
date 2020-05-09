import Combine
import Mockingbird
import Nimble
import Quick
import SwiftUI
@testable import Hymns

/**
 * Tests cases where the `HomeViewModel` performs a search request.
 */
class HomeViewModelSearchSpec: QuickSpec {

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
                    expect(target.state).to(equal(HomeResultState.loading))
                    onChanged(recentSongs)
                    return mock(Notification.self)
                }
                songResultsRepository = mock(SongResultsRepository.self)
                target = HomeViewModel(backgroundQueue: testQueue, historyStore: historyStore,
                                       mainQueue: testQueue, repository: songResultsRepository)

                target.searchActive = true
                testQueue.sync {}

                // clear the invocations made during the setup step
                clearInvocations(on: historyStore)
                clearInvocations(on: songResultsRepository)
            }
            let recentHymns = "Recent hymns"
            let searchParameter = "Wakanda Forever"
            context("with search parameter: \(searchParameter)") {
                context("with nil network response") {
                    beforeEach {
                        given(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)) ~> { _, _ in
                            expect(target.state).to(equal(HomeResultState.loading))
                            return Just(nil).eraseToAnyPublisher()
                        }
                        target.searchParameter = "\(searchParameter) \n  "
                        sleep(1) // allow time for the debouncer to trigger.
                    }
                    it("no label should be showing") {
                        expect(target.label).to(beNil())
                    }
                    it("should not still be loading") {
                        expect(target.state).to(equal(HomeResultState.empty))
                    }
                    it("song results should be empty") {
                        expect(target.songResults).to(beEmpty())
                    }
                    it("should not fetch the recent songs from the history store") {
                        verify(historyStore.recentSongs(onChanged: any())).wasNeverCalled()
                    }
                    it("should fetch the first page") {
                        verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)).wasCalled(exactly(1))
                    }
                }
                context("with a single page of network results") {
                    let classic594 = SongResult(name: "classic594", path: "/en/hymn/h/594?gb=1&query=3")
                    let noHymnType = SongResult(name: "noHymnType", path: "")
                    let newTune7 = SongResult(name: "newTune7", path: "/en/hymn/nt/7")
                    let noHymnNumber = SongResult(name: "noHymnNumber", path: "/en/hymn/h/a")
                    beforeEach {
                        given(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)) ~> { searchInput, pageNumber in
                            expect(target.state).to(equal(HomeResultState.loading))
                            let page = SongResultsPage(results: [classic594, noHymnType, newTune7, noHymnNumber], hasMorePages: false)
                            return Just(page).eraseToAnyPublisher()
                        }
                        target.searchParameter = searchParameter
                        sleep(1) // allow time for the debouncer to trigger.
                    }
                    it("no label should be showing") {
                        expect(target.label).to(beNil())
                    }
                    it("should not still be loading") {
                        expect(target.state).to(equal(HomeResultState.results))
                    }
                    it("should have two results") {
                        expect(target.songResults).to(haveCount(2))
                        expect(target.songResults[0].title).to(equal("classic594"))
                        expect(target.songResults[1].title).to(equal("newTune7"))
                    }
                    it("should not fetch the recent songs from the history store") {
                        verify(historyStore.recentSongs(onChanged: any())).wasNeverCalled()
                    }
                    it("should fetch the first page") {
                        verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)).wasCalled(exactly(1))
                    }
                    context("search parameter cleared") {
                        beforeEach {
                            target.searchParameter = ""
                            sleep(1) // allow time for the debouncer to trigger.
                        }
                        it("\"\(recentHymns)\" label should be showing") {
                            expect(target.label).toNot(beNil())
                            expect(target.label).to(equal(recentHymns))
                        }
                        it("should not still be loading") {
                            expect(target.state).to(equal(HomeResultState.results))
                        }
                        it("should fetch the recent songs from the history store") {
                            verify(historyStore.recentSongs(onChanged: any())).wasCalled(exactly(1))
                        }
                        it("should display recent songs") {
                            expect(target.songResults).to(haveCount(2))
                            expect(target.songResults[0].title).to(equal(recentSongs[0].songTitle))
                            expect(target.songResults[1].title).to(equal(recentSongs[1].songTitle))
                        }
                    }
                    context("deactivate search") {
                        beforeEach {
                            target.searchActive = false
                            sleep(1) // allow time for the debouncer to trigger.
                        }
                        it("\"\(recentHymns)\" label should be showing") {
                            expect(target.label).toNot(beNil())
                            expect(target.label).to(equal(recentHymns))
                        }
                        it("should not still be loading") {
                            expect(target.state).to(equal(HomeResultState.results))
                        }
                        it("should fetch the recent songs from the history store") {
                            verify(historyStore.recentSongs(onChanged: any())).wasCalled(exactly(1))
                        }
                        it("should display recent songs") {
                            expect(target.songResults).to(haveCount(2))
                            expect(target.songResults[0].title).to(equal(recentSongs[0].songTitle))
                            expect(target.songResults[1].title).to(equal(recentSongs[1].songTitle))
                        }
                    }
                }
                context("with a two pages of network results") {
                    let page1 = Array(1...10).map { int -> SongResult in
                        return SongResult(name: "classic\(int)", path: "/en/hymn/h/\(int)")
                    }
                    let page2 = Array(20...23).map { int -> SongResult in
                        return SongResult(name: "classic\(int)", path: "/en/hymn/h/\(int)")
                    }
                    beforeEach {
                        given(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)) ~> { searchInput, pageNumber in
                            expect(target.state).to(equal(HomeResultState.loading))
                            let page = SongResultsPage(results: page1, hasMorePages: true)
                            return Just(page).eraseToAnyPublisher()
                        }
                        given(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 2)) ~> { searchInput, pageNumber in
                            expect(target.state).to(equal(HomeResultState.results))
                            let page = SongResultsPage(results: page2, hasMorePages: false)
                            return Just(page).eraseToAnyPublisher()
                        }
                        target.searchParameter = searchParameter
                        sleep(1) // allow time for the debouncer to trigger.
                    }
                    it("should have the first page of results") {
                        expect(target.songResults).to(haveCount(10))
                        for (index, num) in Array(1...10).enumerated() {
                            expect(target.songResults[index].title).to(equal("classic\(num)"))
                        }
                    }
                    it("should not fetch the recent songs from the history store") {
                        verify(historyStore.recentSongs(onChanged: any())).wasNeverCalled()
                    }
                    it("should fetch the first page") {
                        verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 1)).wasCalled(exactly(1))
                    }
                    describe("load on nonexistent result") {
                        beforeEach {
                            target.loadMore(at: SongResultViewModel(title: "does not exist", destinationView: EmptyView().eraseToAnyView()))
                        }
                        it("should not fetch the next page") {
                            verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 2)).wasNeverCalled()
                        }
                    }
                    describe("load more does not reach threshold") {
                        beforeEach {
                            target.loadMore(at: SongResultViewModel(title: "classic6", destinationView: EmptyView().eraseToAnyView()))
                        }
                        it("should not fetch the next page") {
                            verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 2)).wasNeverCalled()
                        }
                    }
                    describe("load more meets threshold") {
                        beforeEach {
                            target.loadMore(at: SongResultViewModel(title: "classic7", destinationView: EmptyView().eraseToAnyView()))
                            testQueue.sync {}
                            testQueue.sync {}
                            testQueue.sync {}
                        }
                        it("should append the second page onto the first page") {
                            expect(target.songResults).to(haveCount(14))
                            for (index, num) in (Array(1...10) + Array(20...23)).enumerated() {
                                expect(target.songResults[index].title).to(equal("classic\(num)"))
                            }
                        }
                        it("should not fetch the recent songs from the history store") {
                            verify(historyStore.recentSongs(onChanged: any())).wasNeverCalled()
                        }
                        it("should fetch the next page") {
                            verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 2)).wasCalled(exactly(1))
                        }
                        describe("no more pages to load") {
                            beforeEach {
                                target.loadMore(at: SongResultViewModel(title: "classic23", destinationView: EmptyView().eraseToAnyView()))
                            }
                            it("should not fetch the next page") {
                                verify(songResultsRepository.search(searchParameter: searchParameter, pageNumber: 3)).wasNeverCalled()
                            }
                        }
                    }
                }
            }
        }
    }
}
