import Combine
import Quick
import Mockingbird
import Nimble
@testable import Hymns

class DisplayHymnViewModelSpec: QuickSpec {

    override func spec() {
        let classic1151 = HymnIdentifier(hymnType: .classic, hymnNumber: "1151")
        let newSong145 = HymnIdentifier(hymnType: .newSong, hymnNumber: "145")

        describe("DisplayHymnViewModel") {
            // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
            let testQueue = DispatchQueue(label: "test_queue")
            var hymnsRepository: HymnsRepositoryMock!
            var historyStore: HistoryStoreMock!
            var target: DisplayHymnViewModel!
            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
                historyStore = mock(HistoryStore.self)
            }
            describe("fetching hymn") {
                context("with nil repository result") {
                    beforeEach {
                        target = DisplayHymnViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, historyStore: historyStore)
                        given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(nil).assertNoFailure().eraseToAnyPublisher()}
                    }
                    describe("performing fetch") {
                        beforeEach {
                            target.fetchHymn()
                            testQueue.sync {}
                        }
                        it("title should be empty") {
                            expect(target.title).to(beEmpty())
                        }
                        it("should not store any song into the history store") {
                            verify(historyStore.storeRecentSong(hymnToStore: any(), songTitle: any())).wasNeverCalled()
                        }
                        it("should call hymnsRepository.getHymn") {
                            verify(hymnsRepository.getHymn(hymnIdentifier: classic1151)).wasCalled(exactly(1))
                        }
                    }
                }
                context("with valid repository results") {
                    context("for a classic hymn 1151") {
                        beforeEach {
                            target = DisplayHymnViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, mainQueue: testQueue, historyStore: historyStore)
                            let hymn = Hymn(title: "title", metaData: [MetaDatum](), lyrics: [Verse]())
                            given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(hymn).assertNoFailure().eraseToAnyPublisher()}
                        }
                        describe("fetching hymn") {
                            beforeEach {
                                target.fetchHymn()
                                testQueue.sync {}
                            }
                            let expectedTitle = "Hymn 1151"
                            it("title should be '\(expectedTitle)'") {
                                expect(target.title).to(equal(expectedTitle))
                            }
                            it("should store the song into the history store") {
                                verify(historyStore.storeRecentSong(hymnToStore: classic1151, songTitle: expectedTitle)).wasCalled(exactly(1))
                            }
                            it("should call hymnsRepository.getHymn") {
                                verify(hymnsRepository.getHymn(hymnIdentifier: classic1151)).wasCalled(exactly(1))
                            }
                        }
                    }
                    context("for new song 145") {
                        beforeEach {
                            target = DisplayHymnViewModel(hymnToDisplay: newSong145, hymnsRepository: hymnsRepository, mainQueue: testQueue, historyStore: historyStore)
                        }
                        let expectedTitle = "In my spirit, I can see You as You are"
                        context("title contains 'Hymn: '") {
                            beforeEach {
                                let hymnWithHymnColonTitle = Hymn(title: "Hymn: In my spirit, I can see You as You are", metaData: [MetaDatum](), lyrics: [Verse]())
                                given(hymnsRepository.getHymn(hymnIdentifier: newSong145)) ~> {Just(hymnWithHymnColonTitle).assertNoFailure().eraseToAnyPublisher()}
                            }
                            describe("fetching hymn") {
                                beforeEach {
                                    target.fetchHymn()
                                    testQueue.sync {}
                                }
                                it("title should be '\(expectedTitle)'") {
                                    expect(target.title).to(equal(expectedTitle))
                                }
                                it("should store the song into the history store") {
                                    verify(historyStore.storeRecentSong(hymnToStore: newSong145, songTitle: expectedTitle)).wasCalled(exactly(1))
                                }
                                it("should call hymnsRepository.getHymn") {
                                    verify(hymnsRepository.getHymn(hymnIdentifier: newSong145)).wasCalled(exactly(1))
                                }
                            }
                        }
                        context("title does not contains 'Hymn: '") {
                            beforeEach {
                                let hymnWithOutHymnColonTitle = Hymn(title: "In my spirit, I can see You as You are", metaData: [MetaDatum](), lyrics: [Verse]())
                                given(hymnsRepository.getHymn(hymnIdentifier: newSong145)) ~> {Just(hymnWithOutHymnColonTitle).assertNoFailure().eraseToAnyPublisher()}
                            }
                            describe("fetching hymn") {
                                beforeEach {
                                    target.fetchHymn()
                                    testQueue.sync {}
                                }
                                it("title should be '\(expectedTitle)'") {
                                    expect(target.title).to(equal(expectedTitle))
                                }
                                it("should store the song into the history store") {
                                    verify(historyStore.storeRecentSong(hymnToStore: newSong145, songTitle: expectedTitle)).wasCalled(exactly(1))
                                }
                                it("should call hymnsRepository.getHymn") {
                                    verify(hymnsRepository.getHymn(hymnIdentifier: newSong145)).wasCalled(exactly(1))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
