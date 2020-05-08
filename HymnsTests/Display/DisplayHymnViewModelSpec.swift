import Combine
import Mockingbird
import Nimble
import Quick
@testable import Hymns

class DisplayHymnViewModelSpec: QuickSpec {

    override func spec() {
        describe("DisplayHymnViewModel") {
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
                        target = DisplayHymnViewModel(backgroundQueue: testQueue, hymnToDisplay: classic1151, hymnsRepository: hymnsRepository,
                                                      favoritesStore: favoritesStore, historyStore: historyStore)
                        given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                            Just(nil).assertNoFailure().eraseToAnyPublisher()
                        }
                    }
                    describe("performing fetch") {
                        beforeEach {
                            target.fetchHymn()
                        }
                        it("title should be empty") {
                            expect(target.title).to(beEmpty())
                        }
                        it("should not store any song into the history store") {
                            verify(historyStore.storeRecentSong(hymnToStore: any(), songTitle: any())).wasNeverCalled()
                        }
                        it("should call hymnsRepository.getHymn") {
                            verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
                        }
                    }
                }
                context("with valid repository results") {
                    context("for a classic hymn 1151") {
                        beforeEach {
                            target = DisplayHymnViewModel(backgroundQueue: testQueue, hymnToDisplay: classic1151, hymnsRepository: hymnsRepository,
                                                          mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore)
                            let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse]())
                            given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                                Just(hymn).assertNoFailure().eraseToAnyPublisher()
                            }
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
                                    testQueue.sync {}
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
                                    verify(hymnsRepository.getHymn(classic1151)).wasCalled(exactly(1))
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
                                it("should have lyrics") {
                                    expect(target.lyrics).to(equal([Verse]()))
                                }
                            }
                        }
                    }
                    context("for new song 145") {
                        beforeEach {
                            target = DisplayHymnViewModel(backgroundQueue: testQueue, hymnToDisplay: newSong145, hymnsRepository: hymnsRepository,
                                                          mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore)
                        }
                        let expectedTitle = "In my spirit, I can see You as You are"
                        context("title contains 'Hymn: '") {
                            beforeEach {
                                let hymnWithHymnColonTitle = UiHymn(hymnIdentifier: newSong145, title: "Hymn: In my spirit, I can see You as You are", lyrics: [Verse]())
                                given(hymnsRepository.getHymn(newSong145)) ~> { _ in
                                    Just(hymnWithHymnColonTitle).assertNoFailure().eraseToAnyPublisher()
                                }
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
                                        testQueue.sync {}
                                        testQueue.sync {}
                                    }
                                    it("title should be '\(expectedTitle)'") {
                                        expect(target.title).to(equal(expectedTitle))
                                    }
                                    it("should store the song into the history store") {
                                        verify(historyStore.storeRecentSong(hymnToStore: newSong145, songTitle: expectedTitle)).wasCalled(exactly(1))
                                    }
                                    it("should call hymnsRepository.getHymn") {
                                        verify(hymnsRepository.getHymn(newSong145)).wasCalled(exactly(1))
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
                                let hymnWithOutHymnColonTitle = UiHymn(hymnIdentifier: newSong145, title: "In my spirit, I can see You as You are", lyrics: [Verse]())
                                given(hymnsRepository.getHymn(newSong145)) ~> { _ in
                                    Just(hymnWithOutHymnColonTitle).assertNoFailure().eraseToAnyPublisher()
                                }
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
                                        testQueue.sync {}
                                        testQueue.sync {}
                                    }
                                    it("title should be '\(expectedTitle)'") {
                                        expect(target.title).to(equal(expectedTitle))
                                    }
                                    it("should store the song into the history store") {
                                        verify(historyStore.storeRecentSong(hymnToStore: newSong145, songTitle: expectedTitle)).wasCalled(exactly(1))
                                    }
                                    it("should call hymnsRepository.getHymn") {
                                        verify(hymnsRepository.getHymn(newSong145)).wasCalled(exactly(1))
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
                        context("chords are empty") {
                            beforeEach {
                                // implement
                            }
                            describe("fetching hymn") {
                                beforeEach {
                                    // implement
                                }
                                it("Chords url should be nil") {
                                    //expect(target.chordsUrl).to(beNil())
                                }
                                it("Chords url should not be prefetched") {
                                    // implement
                                }
                                it("Guitar url should be nil") {
                                    //expect(target.guitarUrl).to(beNil())
                                }
                                it("Guitar url should not be prefetched") {
                                    // implement
                                }
                                it("Piano url should be nil") {
                                    //expect(target.guitarUrl).to(beNil())
                                }
                                it("Piano url not be prefetched") {
                                    // implement
                                }
                            }
                        }
                        context("chords are filled") {
                            beforeEach {
                                // implement
                            }
                            describe("fetching hymn") {
                                beforeEach {
                                    // implement
                                }
                                let expectedChordsUrl = "/en/hymn/c/1151/f=gtpdf"
                                it("Chords url should be \(expectedChordsUrl)") {
                                    //expect(target.chordsUrl).to(equal(URL(string: expectedChordsUrl)))
                                }
                                it("Chords url should be prefetched") {
                                    // implement
                                }
                                let expectedGuitarUrl = "/en/hymn/c/1151/f=pdf"
                                it("Guitar url should be \(expectedGuitarUrl)") {
                                    //expect(target.guitarUrl).to(equal(URL(string: expectedGuitarUrl)))
                                }
                                it("Guitar url should be prefetched") {
                                    // implement
                                }
                                let expectedPianoUrl = "/en/hymn/c/1151/f=ppdf"
                                it("Piano url should be \(expectedPianoUrl)") {
                                    //expect(target.pianoUrl).to(equal(URL(string: expectedPianoUrl)))
                                }
                                it("Piano url should be prefetched") {
                                    // implement
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
