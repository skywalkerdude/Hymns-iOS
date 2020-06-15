import Combine
import AVFoundation

class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private weak var player: AVPlayer?
    private var timeObservation: Any?
    private var paused = false

    init(player: AVPlayer) {
        self.player = player

        // Periodically observe the player's current time, whilst playing
        timeObservation
            = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.2, preferredTimescale: 200), queue: nil) { [weak self] time in
                guard let self = self else { return }
                guard !self.paused else { return } // we've been told to pause our updates
                self.publisher.send(time.seconds) // publish the new player time
        }
    }

    deinit {
        if let player = player,
            let observer = timeObservation {
            player.removeTimeObserver(observer)
        }
    }

    func play() {
        paused = false
    }

    func pause() {
        paused = true
    }
}
