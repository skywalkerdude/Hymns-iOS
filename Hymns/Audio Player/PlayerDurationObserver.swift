import Combine
import AVFoundation

class PlayerDurationObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var cancellable: AnyCancellable?

    init(player: AVPlayer) {
        let durationKeyPath: KeyPath<AVPlayer, CMTime?> = \.currentItem?.duration
        cancellable = player.publisher(for: durationKeyPath).sink { duration in
            guard let duration = duration else { return }
            guard duration.isNumeric else { return }
            self.publisher.send(duration.seconds)
        }
    }

    deinit {
        cancellable?.cancel()
    }
}
