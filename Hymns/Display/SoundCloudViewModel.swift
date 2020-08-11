import Resolver

class SoundCloudViewModel: ObservableObject {

    private let userDefaultsManager: UserDefaultsManager
    @Published var activeTimer: Timer.TimerPublisher

    @Published var showSoundCloudMinimizeTooltip: Bool {
        willSet {
            userDefaultsManager.showSoundCloudMinimizeTooltip = newValue
            print("bbug will set timer called", userDefaultsManager.showSoundCloudMinimizeTooltip)
        }
    }

    init(userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.userDefaultsManager = userDefaultsManager
        self.showSoundCloudMinimizeTooltip = userDefaultsManager.showSoundCloudMinimizeTooltip
        print("bbug init")
        self.activeTimer = Timer.publish(every: 2, on: .main, in: .common)
        if userDefaultsManager.showSoundCloudMinimizeTooltip {
        self.activeTimer.connect()
        print("bbug connected")
        }
    }

    func dismissToolTip() {
        showSoundCloudMinimizeTooltip = false
        print("bbug dismiss called")
        self.activeTimer.connect().cancel()
    }
}
