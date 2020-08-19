import AVFoundation
import Combine
import Resolver
import WebKit

class SoundCloudViewModel: ObservableObject {

    @UserDefault("has_seen_soundcloud_minimize_tooltip", defaultValue: false) var hasSeenSoundCloudMinimizeTooltip: Bool

    @Published var url: URL
    @Published var showMinimizeCaret: Bool = false
    @Published var showMinimizeToolTip: Bool = false

    private var timerConnection: Cancellable?

    init(url: URL) {
        self.url = url
        timerConnection = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().sink(receiveValue: { [weak self ]_ in
            guard let self = self else { return }
            if AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint {
                // Media is playing
                self.showMinimizeCaret = true
                if !self.hasSeenSoundCloudMinimizeTooltip {
                    self.showMinimizeToolTip = true
                }
            } else {
                self.showMinimizeCaret = false
            }
        })
    }

    deinit {
        timerConnection?.cancel()
        timerConnection = nil
    }

    func dismissToolTip() {
        showMinimizeToolTip = false
        hasSeenSoundCloudMinimizeTooltip = true
    }
}
