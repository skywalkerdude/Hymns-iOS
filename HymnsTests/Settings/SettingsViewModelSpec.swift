import Combine
import Quick
import Mockingbird
import Nimble
@testable import Hymns

class SettingsViewModelSpec: QuickSpec {

    override func spec() {
        describe("SettingsViewModel") {
            var application: ApplicationMock!
            var target: SettingsViewModel!
            beforeEach {
                application = mock(Application.self)
                target = SettingsViewModel(application: application)
            }

            describe("settings array") {
                var settings: [AnySettingViewModel]!
                beforeEach {
                    settings = target.settings
                }

                let settingsSize = 1 // Change this value as we add more settings.
                it("should contain exactly \(settingsSize) item") {
                    expect(settings).to(haveCount(settingsSize))
                }
            }
        }
    }
}
