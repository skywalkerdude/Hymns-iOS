import Resolver

class SoundCloudViewModel: ObservableObject {

    private let userDefaultsManager: UserDefaultsManager

    @Published var showSoundCloudMinimizeTooltip: Bool {
        willSet {
            userDefaultsManager.showSoundCloudMinimizeTooltip = newValue
        }
    }
    @Published var activeTimer: Timer.TimerPublisher

    init(userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.userDefaultsManager = userDefaultsManager
        self.showSoundCloudMinimizeTooltip = userDefaultsManager.showSoundCloudMinimizeTooltip
        self.activeTimer = Timer.publish(every: 2, on: .main, in: .common)
        if userDefaultsManager.showSoundCloudMinimizeTooltip {
            self.activeTimer.connect()
        }
    }

    func dismissToolTip() {
        showSoundCloudMinimizeTooltip = false
        self.activeTimer.connect().cancel()
    }
}
