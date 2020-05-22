import Quick
import Nimble
@testable import Hymns

// swiftlint:disable:next type_name
class DisplayHymnBottomBarViewModelSpec: QuickSpec {

    override func spec() {
        describe("DisplayHymnBottomBarViewModel") {

            var target: DisplayHymnBottomBarViewModel!

            describe("init") {
                beforeEach {
                    target = DisplayHymnBottomBarViewModel(hymnToDisplay: classic1151)
                }
                it("should set up the info dialog") {
                    expect(target.songInfo).to(equal(SongInfoDialogViewModel(hymnToDisplay: classic1151)))
                }
            }
        }
    }
}
