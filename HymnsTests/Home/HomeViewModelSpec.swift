import Combine
import Mockingbird
import Nimble
import Quick
@testable import Hymns

class HomeViewModelSpec: QuickSpec {

    override func spec() {
        describe("HomeViewModelSpec") {
            // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
            let testQueue = DispatchQueue(label: "test_queue")
            var historyStore: HistoryStoreMock!
            var songResultsRepository: SongResultsRepositoryMock!
            var target: HomeViewModel!

            let recentSongs = [RecentSong(hymnIdentifier: classic1151, songTitle: "Hymn 1151"),
                               RecentSong(hymnIdentifier: cebuano123, songTitle: "Naghigda sa lubong\\u2014")]
            beforeEach {
                historyStore = mock(HistoryStore.self)
                given(historyStore.recentSongs()) ~> {
                    Just(recentSongs).mapError({ _ -> ErrorType in
                        .data(description: "This will never get called")
                    }).eraseToAnyPublisher()
                }
                songResultsRepository = mock(SongResultsRepository.self)
            }
            let recentHymns = "Recent hymns"
            context("data store error") {
                beforeEach {
                    given(historyStore.recentSongs()) ~> {
                        Just([RecentSong]())
                            .tryMap({ _ -> [RecentSong] in
                                throw URLError(.badServerResponse)
                            }).mapError({ _ -> ErrorType in
                                .data(description: "forced data error")
                            }).eraseToAnyPublisher()
                    }
                    target = HomeViewModel(backgroundQueue: testQueue, historyStore: historyStore,
                                           mainQueue: testQueue, repository: songResultsRepository)
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("\"\(recentHymns)\" label should not be showing") {
                    expect(target.label).to(beNil())
                }
                it("should display empty results") {
                    expect(target.state).to(equal(HomeResultState.results))
                    expect(target.songResults).to(beEmpty())
                }
                it("should fetch the recent songs from the history store") {
                    verify(historyStore.recentSongs()).wasCalled(exactly(1))
                }
            }
            context("data store empty") {
                beforeEach {
                    given(historyStore.recentSongs()) ~> {
                        Just([RecentSong]()).mapError({ _ -> ErrorType in
                            .data(description: "This will never get called")
                        }).eraseToAnyPublisher()
                    }
                    target = HomeViewModel(backgroundQueue: testQueue, historyStore: historyStore,
                                           mainQueue: testQueue, repository: songResultsRepository)
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("\"\(recentHymns)\" label should not be showing") {
                    expect(target.label).to(beNil())
                }
                it("should display empty results") {
                    expect(target.state).to(equal(HomeResultState.results))
                    expect(target.songResults).to(beEmpty())
                }
                it("should fetch the recent songs from the history store") {
                    verify(historyStore.recentSongs()).wasCalled(exactly(1))
                }
            }
            context("recent songs") {
                beforeEach {
                    target = HomeViewModel(backgroundQueue: testQueue, historyStore: historyStore,
                                           mainQueue: testQueue, repository: songResultsRepository)
                    testQueue.sync {}
                    testQueue.sync {}
                }
                it("\"\(recentHymns)\" label should be showing") {
                    expect(target.label).toNot(beNil())
                }
                it("\"\(recentHymns)\" label should be \(recentHymns)") {
                    expect(target.label).to(equal(recentHymns))
                }
                it("should display results") {
                    expect(target.state).to(equal(HomeResultState.results))
                }
                it("should fetch the recent songs from the history store") {
                    verify(historyStore.recentSongs()).wasCalled(exactly(1))
                }
                it("should display recent songs") {
                    expect(target.songResults).to(haveCount(2))
                    expect(target.songResults[0].title).to(equal(recentSongs[0].songTitle))
                    expect(target.songResults[1].title).to(equal(recentSongs[1].songTitle))
                }
            }
            context("search active") {
                beforeEach {
                    target = HomeViewModel(backgroundQueue: testQueue, historyStore: historyStore,
                                           mainQueue: testQueue, repository: songResultsRepository)
                    target.searchActive = true
                    testQueue.sync {}
                    testQueue.sync {}
                }
                context("with empty search parameter") {
                    it("\"\(recentHymns)\" label should be showing") {
                        expect(target.label).toNot(beNil())
                        expect(target.label).to(equal(recentHymns))
                    }
                    it("should be showing results") {
                        expect(target.state).to(equal(HomeResultState.results))
                    }
                    it("should fetch the recent songs from the history store") {
                        verify(historyStore.recentSongs()).wasCalled(exactly(1))
                    }
                    it("should display recent songs") {
                        expect(target.songResults).toEventually(haveCount(2))
                        expect(target.songResults[0].title).to(equal(recentSongs[0].songTitle))
                        expect(target.songResults[1].title).to(equal(recentSongs[1].songTitle))
                    }
                    it("should not call songResultsRepository.search") {
                        verify(songResultsRepository.search(searchParameter: any(), pageNumber: any())).wasNeverCalled()
                    }
                }
                describe("clear mock invocations called from setup") {
                    beforeEach {
                        clearInvocations(on: historyStore)
                    }
                    context("with numeric search parameter") {
                        beforeEach {
                            target.searchParameter = "198 "
                            sleep(1) // allow time for the debouncer to trigger.
                        }
                        it("no label should be showing") {
                            expect(target.label).to(beNil())
                        }
                        it("should be showing results") {
                            expect(target.state).to(equal(HomeResultState.results))
                        }
                        it("song results should contain matching numbers") {
                            expect(target.songResults).to(haveCount(2))
                            expect(target.songResults[0].title).to(equal("Hymn 198"))
                            expect(target.songResults[1].title).to(equal("Hymn 1198"))
                        }
                        it("should not fetch the recent songs from the history store") {
                            verify(historyStore.recentSongs()).wasNeverCalled()
                        }
                        it("should not call songResultsRepository.search") {
                            verify(songResultsRepository.search(searchParameter: any(), pageNumber: any())).wasNeverCalled()
                        }
                    }
                    context("with invalid numeric search parameter") {
                        beforeEach {
                            target.searchParameter = "2000 " // number is larger than any valid song
                            sleep(1) // allow time for the debouncer to trigger.
                        }
                        it("no label should be showing") {
                            expect(target.label).to(beNil())
                        }
                        it("should be showing no results state") {
                            expect(target.state).to(equal(HomeResultState.empty))
                        }
                        it("song results should contain matching numbers") {
                            expect(target.songResults).to(beEmpty())
                        }
                        it("should not fetch the recent songs from the history store") {
                            verify(historyStore.recentSongs()).wasNeverCalled()
                        }
                        it("should not call songResultsRepository.search") {
                            verify(songResultsRepository.search(searchParameter: any(), pageNumber: any())).wasNeverCalled()
                        }
                    }
                }
            }
        }
    }
}
