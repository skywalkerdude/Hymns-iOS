import Combine
import Mockingbird
import Nimble
import Quick
@testable import Hymns

class DisplayHymnViewModelSpec: QuickSpec {

    override func spec() {
        describe("DisplayHymnViewModel") {
            // https://www.vadimbulavin.com/unit-testing-async-code-in-swift/
            let testQueue = DispatchQueue(label: "test_queue")
            var hymnsRepository: HymnsRepositoryMock!
            var favoritesStore: FavoritesStoreMock!
            var historyStore: HistoryStoreMock!
            var target: DisplayHymnViewModel!
            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
                favoritesStore = mock(FavoritesStore.self)
                historyStore = mock(HistoryStore.self)
            }
            describe("fetching hymn") {
                context("with nil repository result") {
                    beforeEach {
                        target = DisplayHymnViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository,
                                                      mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore)
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
                            target = DisplayHymnViewModel(hymnToDisplay: classic1151, hymnsRepository: hymnsRepository,
                                                          mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore)
                            let hymn = Hymn(title: "title", metaData: [MetaDatum](), lyrics: [Verse]())
                            given(hymnsRepository.getHymn(hymnIdentifier: classic1151)) ~> {Just(hymn).assertNoFailure().eraseToAnyPublisher()}
                        }
                        context("is favorited") {
                            beforeEach {
                                given(favoritesStore.isFavorite(hymnIdentifier: classic1151)) ~> true
                                given(favoritesStore.observeFavoriteStatus(hymnIdentifier: classic1151, action: any())) ~> { (hymnIdentifier, action) in
                                    action(true)
                                    return mock(Notification.self)
                                }
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
                                it("should be favorited") {
                                    expect(target.isFavorited).to(beTrue())
                                }
                                it("should call favoritesStore.isFavorite") {
                                    verify(favoritesStore.isFavorite(hymnIdentifier: classic1151)).wasCalled(exactly(1))
                                }
                                it("should observe its favorite status") {
                                    verify(favoritesStore.observeFavoriteStatus(hymnIdentifier: classic1151, action: any())).wasCalled(exactly(1))
                                }
                            }
                        }
                    }
                    context("for new song 145") {
                        beforeEach {
                            target = DisplayHymnViewModel(hymnToDisplay: newSong145, hymnsRepository: hymnsRepository,
                                                          mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore)
                        }
                        let expectedTitle = "In my spirit, I can see You as You are"
                        context("title contains 'Hymn: '") {
                            beforeEach {
                                let hymnWithHymnColonTitle = Hymn(title: "Hymn: In my spirit, I can see You as You are", metaData: [MetaDatum](), lyrics: [Verse]())
                                given(hymnsRepository.getHymn(hymnIdentifier: newSong145)) ~> {Just(hymnWithHymnColonTitle).assertNoFailure().eraseToAnyPublisher()}
                            }
                            context("is not favorited") {
                                beforeEach {
                                    given(favoritesStore.isFavorite(hymnIdentifier: newSong145)) ~> false
                                    given(favoritesStore.observeFavoriteStatus(hymnIdentifier: newSong145, action: any())) ~> { (hymnIdentifier, action) in
                                        action(false)
                                        return mock(Notification.self)
                                    }
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
                                    it("should not be favorited") {
                                        expect(target.isFavorited).to(beFalse())
                                    }
                                    it("should call favoritesStore.isFavorite") {
                                        verify(favoritesStore.isFavorite(hymnIdentifier: newSong145)).wasCalled(exactly(1))
                                    }
                                    it("should observe its favorite status") {
                                        verify(favoritesStore.observeFavoriteStatus(hymnIdentifier: newSong145, action: any())).wasCalled(exactly(1))
                                    }
                                }
                            }
                        }
                        context("title does not contains 'Hymn: '") {
                            beforeEach {
                                let hymnWithOutHymnColonTitle = Hymn(title: "In my spirit, I can see You as You are", metaData: [MetaDatum](), lyrics: [Verse]())
                                given(hymnsRepository.getHymn(hymnIdentifier: newSong145)) ~> {Just(hymnWithOutHymnColonTitle).assertNoFailure().eraseToAnyPublisher()}
                            }
                            context("favorite status updated from true to false") {
                                beforeEach {
                                    given(favoritesStore.isFavorite(hymnIdentifier: newSong145)) ~> true
                                    given(favoritesStore.observeFavoriteStatus(hymnIdentifier: newSong145, action: any())) ~> { (hymnIdentifier, action) in
                                        action(false)
                                        return mock(Notification.self)
                                    }
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
                                    it("should not be favorited") {
                                        expect(target.isFavorited).to(beFalse())
                                    }
                                    it("should call favoritesStore.isFavorite") {
                                        verify(favoritesStore.isFavorite(hymnIdentifier: newSong145)).wasCalled(exactly(1))
                                    }
                                    it("should observe its favorite status") {
                                        verify(favoritesStore.observeFavoriteStatus(hymnIdentifier: newSong145, action: any())).wasCalled(exactly(1))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
