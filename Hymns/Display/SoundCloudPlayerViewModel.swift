import AVFoundation
import Combine
import RealmSwift
import Resolver
import SwiftUI

class SoundCloudPlayerViewModel: ObservableObject {

    @Published var showPlayer: Bool = false

    @Binding var dialogModel: DialogViewModel<AnyView>?

    private var timerConnection: Cancellable?

    init(dialogModel: Binding<DialogViewModel<AnyView>?>) {
        self._dialogModel = dialogModel
        timerConnection = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().sink(receiveValue: { [weak self ]_ in
            guard let self = self else { return }
            self.showPlayer = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        })
    }

    deinit {
        timerConnection?.cancel()
        timerConnection = nil
    }

    func stopPlayer() {
        self.timerConnection?.cancel()
        self.showPlayer = false
        self.dialogModel = nil
    }
}
