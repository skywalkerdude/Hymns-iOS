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
            var webViewPreloader: WebViewPreloaderMock!
            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
                favoritesStore = mock(FavoritesStore.self)
                historyStore = mock(HistoryStore.self)
                webViewPreloader = mock(WebViewPreloader.self)
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
                        it("lyrics should be nil") {
                            expect(target.lyrics).to(beNil())
                        }
                        it("chords should be nil") {
                            expect(target.chordsUrl).to(beNil())
                        }
                        it("guitar url should be nil") {
                            expect(target.guitarUrl).to(beNil())
                        }
                        it("piano url should be nil") {
                            expect(target.pianoUrl).to(beNil())
                        }
                        it("should not perform any prefetching") {
                            verify(webViewPreloader.preload(url: any())).wasNeverCalled()
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
                                                          mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore, webviewCache: webViewPreloader)
                            let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse](), pdfSheet: Hymns.MetaDatum(name: "Lead Sheet", data: [Hymns.Datum(value: "Piano", path: "/en/hymn/c/1151/f=ppdf"), Hymns.Datum(value: "Guitar", path: "/en/hymn/c/1151/f=pdf"), Hymns.Datum(value: "Text", path: "/en/hymn/c/1151/f=gtpdf")]))
                            given(hymnsRepository.getHymn(classic1151)) ~> { _ in
                                Just(hymn).assertNoFailure().eraseToAnyPublisher()
                            }
                        }
                        context("is favorited") {
                            beforeEach {
                                given(favoritesStore.isFavorite(hymnIdentifier: classic1151)) ~> true
                                given(favoritesStore.observeFavoriteStatus(hymnIdentifier: classic1151, action: any())) ~> mock(Notification.self)
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
                                let chordsUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=gtpdf")!
                                it("chords url should be \(String(describing: chordsUrl))") {
                                    expect(target.chordsUrl).to(equal(chordsUrl))
                                }
                                it("chords url should be prefetched") {
                                    verify(webViewPreloader.preload(url: chordsUrl)).wasCalled(exactly(1))
                                }
                                let guitarUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=pdf")!
                                it("guitar url should be \(String(describing: guitarUrl))") {
                                    expect(target.guitarUrl).to(equal(guitarUrl))
                                }
                                it("guitar url should be prefetched") {
                                    verify(webViewPreloader.preload(url: guitarUrl)).wasCalled(exactly(1))
                                }
                                let pianoUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=ppdf")!
                                it("piano url should be \(String(describing: pianoUrl))") {
                                    expect(target.pianoUrl).to(equal(pianoUrl))
                                }
                                it("piano url should be prefetched") {
                                    verify(webViewPreloader.preload(url: pianoUrl)).wasCalled(exactly(1))
                                }
                            }
                        }
                    }
                    context("for new song 145") {
                        beforeEach {
                            target = DisplayHymnViewModel(backgroundQueue: testQueue, hymnToDisplay: newSong145, hymnsRepository: hymnsRepository,
                                                          mainQueue: testQueue, favoritesStore: favoritesStore, historyStore: historyStore,
                                                          webviewCache: webViewPreloader)
                        }
                        let expectedTitle = "In my spirit, I can see You as You are"
                        context("title contains 'Hymn: '") {
                            beforeEach {
                                let hymnWithHymnColonTitle = UiHymn(hymnIdentifier: newSong145, title: "Hymn: In my spirit, I can see You as You are", lyrics: [Verse](), pdfSheet: Hymns.MetaDatum(name: "Lead Sheet", data: [Hymns.Datum(value: "Piano", path: "/en/hymn/c/1151/f=ppdf"), Hymns.Datum(value: "Guitar", path: "/en/hymn/c/1151/f=pdf"), Hymns.Datum(value: "Text", path: "/en/hymn/c/1151/f=gtpdf")]))
                                given(hymnsRepository.getHymn(newSong145)) ~> { _ in
                                    Just(hymnWithHymnColonTitle).assertNoFailure().eraseToAnyPublisher()
                                }
                            }
                            context("is not favorited") {
                                beforeEach {
                                    given(favoritesStore.isFavorite(hymnIdentifier: newSong145)) ~> false
                                    given(favoritesStore.observeFavoriteStatus(hymnIdentifier: newSong145, action: any())) ~> mock(Notification.self)
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
                                    let chordsUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=gtpdf")!
                                    it("chords url should be \(String(describing: chordsUrl))") {
                                        expect(target.chordsUrl).to(equal(chordsUrl))
                                    }
                                    it("chords url should be prefetched") {
                                        verify(webViewPreloader.preload(url: chordsUrl)).wasCalled(exactly(1))
                                    }
                                    let guitarUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=pdf")!
                                    it("guitar url should be \(String(describing: guitarUrl))") {
                                        expect(target.guitarUrl).to(equal(guitarUrl))
                                    }
                                    it("guitar url should be prefetched") {
                                        verify(webViewPreloader.preload(url: guitarUrl)).wasCalled(exactly(1))
                                    }
                                    let pianoUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=ppdf")!
                                    it("piano url should be \(String(describing: pianoUrl))") {
                                        expect(target.pianoUrl).to(equal(pianoUrl))
                                    }
                                    it("piano url should be prefetched") {
                                        verify(webViewPreloader.preload(url: pianoUrl)).wasCalled(exactly(1))
                                    }
                                }
                            }
                        }
                        context("hymn does not contain sheet music") {
                            beforeEach {
                                let hymnWithoutSheetMusic = UiHymn(hymnIdentifier: newSong145, title: "In my spirit, I can see You as You are", lyrics: [Verse]())
                                given(hymnsRepository.getHymn(newSong145)) ~> { _ in
                                    Just(hymnWithoutSheetMusic).assertNoFailure().eraseToAnyPublisher()
                                }
                                given(favoritesStore.isFavorite(hymnIdentifier: newSong145)) ~> false
                                given(favoritesStore.observeFavoriteStatus(hymnIdentifier: newSong145, action: any())) ~> mock(Notification.self)
                            }
                            describe("fetching hymn") {
                                beforeEach {
                                    target.fetchHymn()
                                    testQueue.sync {}
                                    testQueue.sync {}
                                    testQueue.sync {}
                                }
                                it("should have lyrics") {
                                    expect(target.lyrics).to(equal([Verse]()))
                                }
                                it("chords url should be nil") {
                                    expect(target.chordsUrl).to(beNil())
                                }
                                it("guitar url should be nil") {
                                    expect(target.guitarUrl).to(beNil())
                                }
                                it("piano url should be nil") {
                                    expect(target.pianoUrl).to(beNil())
                                }
                                it("should not perform any prefetching") {
                                    verify(webViewPreloader.preload(url: any())).wasNeverCalled()
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
                    }
                }
            }
        }
    }
}
