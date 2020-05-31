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
            var pdfLoader: PDFLoaderMock!
            beforeEach {
                hymnsRepository = mock(HymnsRepository.self)
                favoritesStore = mock(FavoritesStore.self)
                historyStore = mock(HistoryStore.self)
                pdfLoader = mock(PDFLoader.self)
            }
            describe("fetching hymn") {
                context("with nil repository result") {
                    beforeEach {
                        target = DisplayHymnViewModel(backgroundQueue: testQueue, favoritesStore: favoritesStore, hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, historyStore: historyStore, pdfPreloader: pdfLoader)
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
                        it("should not perform any prefetching") {
                            verify(pdfLoader.load(url: any())).wasNeverCalled()
                        }
                        it("should have no tabs") {
                            expect(target.tabItems).to(beEmpty())
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
                    context("for a classic hymn 1151 and store in recent songs") {
                        beforeEach {
                            target = DisplayHymnViewModel(backgroundQueue: testQueue, favoritesStore: favoritesStore, hymnToDisplay: classic1151, hymnsRepository: hymnsRepository, historyStore: historyStore,
                                                          mainQueue: testQueue, pdfPreloader: pdfLoader, storeInHistoryStore: true)
                            let hymn = UiHymn(hymnIdentifier: classic1151, title: "title", lyrics: [Verse(verseType: VerseType.verse, verseContent: ["Drink! A river pure and clear that’s flowing from the throne;"])], pdfSheet: Hymns.MetaDatum(name: "Lead Sheet", data: [Hymns.Datum(value: "Piano", path: "/en/hymn/c/1151/f=ppdf"), Hymns.Datum(value: "Guitar", path: "/en/hymn/c/1151/f=pdf"), Hymns.Datum(value: "Text", path: "/en/hymn/c/1151/f=gtpdf")]))

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
                                let expectedTitle = "Hymn 1151: Drink! A river pure and clear that’s flowing from the throne;"
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
                                let chordsUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=gtpdf")!
                                it("chords url should be prefetched") {
                                    verify(pdfLoader.load(url: chordsUrl)).wasCalled(exactly(1))
                                }
                                let guitarUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=pdf")!
                                it("guitar url should be prefetched") {
                                    verify(pdfLoader.load(url: guitarUrl)).wasCalled(exactly(1))
                                }
                                let pianoUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=ppdf")!
                                it("piano url should be prefetched") {
                                    verify(pdfLoader.load(url: pianoUrl)).wasCalled(exactly(1))
                                }
                                it("should have four tabs") {
                                    expect(target.tabItems).to(haveCount(4))
                                }
                                it("first tab should be lyrics") {
                                    expect(target.tabItems[0].id).to(equal("Lyrics"))
                                }
                                it("second tab should be chords") {
                                    expect(target.tabItems[1].id).to(equal("Chords"))
                                }
                                it("third tab should be guitar") {
                                    expect(target.tabItems[2].id).to(equal("Guitar"))
                                }
                                it("fourth tab should be piano") {
                                    expect(target.tabItems[3].id).to(equal("Piano"))
                                }
                                it("should have a bottom bar") {
                                    expect(target.bottomBar).to(equal(DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151)))
                                }
                            }
                        }
                    }
                    context("for new song 145") {
                        beforeEach {
                            target = DisplayHymnViewModel(backgroundQueue: testQueue, favoritesStore: favoritesStore, hymnToDisplay: newSong145, hymnsRepository: hymnsRepository, historyStore: historyStore,
                                                          mainQueue: testQueue, pdfPreloader: pdfLoader)
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
                                        verify(historyStore.storeRecentSong(hymnToStore: any(), songTitle: any())).wasNeverCalled()
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
                                    it("chords url should be prefetched") {
                                        verify(pdfLoader.load(url: chordsUrl)).wasCalled(exactly(1))
                                    }
                                    let guitarUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=pdf")!
                                    it("guitar url should be prefetched") {
                                        verify(pdfLoader.load(url: guitarUrl)).wasCalled(exactly(1))
                                    }
                                    let pianoUrl = URL(string: "http://www.hymnal.net/en/hymn/c/1151/f=ppdf")!
                                    it("piano url should be prefetched") {
                                        verify(pdfLoader.load(url: pianoUrl)).wasCalled(exactly(1))
                                    }
                                    it("should have four tabs") {
                                        expect(target.tabItems).to(haveCount(4))
                                    }
                                    it("first tab should be lyrics") {
                                        expect(target.tabItems[0].id).to(equal("Lyrics"))
                                    }
                                    it("second tab should be chords") {
                                        expect(target.tabItems[1].id).to(equal("Chords"))
                                    }
                                    it("third tab should be guitar") {
                                        expect(target.tabItems[2].id).to(equal("Guitar"))
                                    }
                                    it("fourth tab should be piano") {
                                        expect(target.tabItems[3].id).to(equal("Piano"))
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
                                        verify(historyStore.storeRecentSong(hymnToStore: any(), songTitle: any())).wasNeverCalled()
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
                                    it("should have one tab") {
                                        // tabItems should be one because this call is without sheet music
                                        expect(target.tabItems).to(haveCount(1))
                                    }
                                    it("first tab should be lyrics") {
                                        expect(target.tabItems[0].id).to(equal("Lyrics"))
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
