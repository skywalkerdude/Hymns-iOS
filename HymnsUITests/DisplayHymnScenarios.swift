import XCTest

class DisplayHymnScenarios: BaseTestCase {

    override func setUp() {
        super.setUp()
        app.launch()
    }

    func test_maximizePdf() {
        _ = HomeViewCan(app, testCase: self)
            .tapResult("classic1151")
            .openPiano()
            .maximizeSheetMusic()
            .closeSheetMusic()
    }

    func test_shareLyrics() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openShareSheet()
            .waitForButtons("Edit Actions…", timeout: 2)
    }

    func test_tagSheet() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openOverflowMenu()
            .openTagSheet()
            .waitForStaticTexts("Name your tag")
    }

    func test_songInfoDialog() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openOverflowMenu()
            .waitForStaticTexts("Additional options")
            .waitForButtons("Song Info", "Search in SoundCloud", "Search in YouTube")
            .openSongInfo()
            .waitForStaticTexts("Category", "song's category", "Subcategory", "song's subcategory")
    }

    func test_audioPlayer() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openAudioPlayer()
            .waitForButtons("play.circle")
    }

    func test_changeFontSize() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openFontPicker()
            .waitForStaticTexts("Lyrics font size", "Change the song lyrics font size")
            .waitForButtons("Normal", "Large", "Extra Large")
            .pressCancel()
            .waitForStaticTexts("verse 1 line 1")
            .verifyStaticTextsNotExists("Lyrics font size", "Change the song lyrics font size")
    }

    func test_languages() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openLanguages()
            .waitForStaticTexts("Languages", "Change to another language")
            .waitForButtons("Cebuano", "诗歌(简)", "詩歌(繁)", "Dutch", "Tagalog", "Cancel")
            .pressCancel()
            .waitForStaticTexts("verse 1 line 1")
            .verifyStaticTextsNotExists("Languages", "Change to another language")
            .openLanguages()
            .pressButton("诗歌(简)")
            .waitForStaticTexts("Chinese supplement 216", "chinese verse 1 chinese line 1")
    }

    func test_relevant() {
        _ = HomeViewCan(app, testCase: self)
            .waitForButtons("classic1151", "classic40", "classic2", "classic3")
            .tapResult("classic1151")
            .openRelevant()
            .waitForStaticTexts("Relevant songs", "Change to a relevant hymn")
            .waitForButtons("New Tune")
            .pressCancel()
            .waitForStaticTexts("verse 1 line 1")
            .verifyStaticTextsNotExists("Relevant songs", "Change to a relevant hymn")
            .openRelevant()
            .pressButton("New Tune")
            .waitForStaticTexts("Hymn 2", "classic hymn 2 verse 1")
    }
}
