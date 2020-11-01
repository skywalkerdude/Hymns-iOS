import Foundation
import XCTest

public class DisplayHymnViewCan: BaseViewCan {

    override init(_ app: XCUIApplication, testCase: XCTestCase) {
        super.init(app, testCase: testCase)
    }

    public func goBackToHome() -> HomeViewCan {
        _ = pressButton("Go back")
        return HomeViewCan(app, testCase: testCase)
    }

    public func goBackToBrowse() -> BrowseViewCan {
        _ = pressButton("Go back")
        return BrowseViewCan(app, testCase: testCase)
    }

    public func goBackToBrowseResults() -> BrowseResultsViewCan {
        _ = pressButton("Go back")
        return BrowseResultsViewCan(app, testCase: testCase)
    }

    public func openPiano() -> DisplayHymnViewCan {
        return pressButton("Piano")
    }

    public func maximizeSheetMusic() -> DisplayHymnViewCan {
        return pressButton("Maximize music")
    }

    public func closeSheetMusic() -> DisplayHymnViewCan {
        return pressButton("Close")
    }

    public func openShareSheet() -> DisplayHymnViewCan {
        return pressButton("Share lyrics")
    }

    public func openFontPicker() -> DisplayHymnViewCan {
        return pressButton("Change lyrics font size")
    }

    public func openLanguages() -> DisplayHymnViewCan {
        return pressButton("Show languages")
    }

    public func openAudioPlayer() -> DisplayHymnViewCan {
        return pressButton("Play music")
    }

    public func openSpeedPicker() -> DisplayHymnViewCan {
        return pressButton("timer")
    }

    public func openRelevant() -> DisplayHymnViewCan {
        return pressButton("Relevant songs")
    }

    public func openTagSheet() -> DisplayHymnViewCan {
        return pressButton("Tags")
    }

    public func openSongInfo() -> DisplayHymnViewCan {
        return pressButton("Song Info")
    }

    public func openOverflowMenu() -> DisplayHymnViewCan {
        return pressButton("More options")
    }

    public func pressCancel() -> DisplayHymnViewCan {
        return pressButton("Cancel")
    }

    public override func pressButton(_ buttonText: String) -> Self {
        _ = waitForButtons(buttonText)
        for index in 0..<app.buttons.matching(identifier: buttonText).count {
            if app.buttons.matching(identifier: buttonText).element(boundBy: index).isHittable {
                app.buttons.matching(identifier: buttonText).element(boundBy: index).tap()
            }
        }
        return self
    }
}
