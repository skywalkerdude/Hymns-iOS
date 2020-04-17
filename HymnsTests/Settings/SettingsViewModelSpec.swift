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

            context("privacy policy") {
                var privacyPolicyViewModel: SimpleSettingViewModel!
                beforeEach {
                    privacyPolicyViewModel = target.privacyPolicy
                }

                let privacyPolicy = "Privacy Policy"
                it("should have the title \(privacyPolicy)") {
                    expect(privacyPolicyViewModel.title).to(equal(privacyPolicy))
                }

                describe("calling the action") {
                    it("should open the link too the privacy policy") {
                        let url = URL(string: "https://app.termly.io/document/privacy-policy/4b9dd46b-aca9-40ae-ac97-58b47e4b4cac")!
                        privacyPolicyViewModel.action()
                        verify(application.open(url)).wasCalled(exactly(1))
                    }
                }
            }
        }
    }
}
