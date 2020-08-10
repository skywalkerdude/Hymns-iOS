import Resolver

class SoundCloudViewModel: ObservableObject {

    private let userDefaultsManager: UserDefaultsManager

    @Published var showSoundCloudMinimizeTooltip: Bool {
        willSet {
            userDefaultsManager.showSoundCloudMinimizeTooltip = newValue
        }
    }

    init(userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.userDefaultsManager = userDefaultsManager
        self.showSoundCloudMinimizeTooltip = userDefaultsManager.showSoundCloudMinimizeTooltip
    }

    func dismissToolTip() {
        showSoundCloudMinimizeTooltip = false
    }
}
