import Resolver

class SoundCloudViewModel: ObservableObject {

    private let userDefaultsManager: UserDefaultsManager

    @Published var showSoundCloudMinimizeTooltip: Bool {
        willSet {
            userDefaultsManager.hasSeenSoundCloudMinimizeTooltip = true
        }
    }

    @Published var activeTimer: Timer.TimerPublisher

    init(userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.userDefaultsManager = userDefaultsManager
        self.showSoundCloudMinimizeTooltip = false
        self.activeTimer = Timer.publish(every: 1, on: .main, in: .common)
        if !userDefaultsManager.hasSeenSoundCloudMinimizeTooltip {
            self.activeTimer.connect()
        }
    }

    func dismissToolTip() {
        showSoundCloudMinimizeTooltip = false
        self.activeTimer.connect().cancel()
    }
}
