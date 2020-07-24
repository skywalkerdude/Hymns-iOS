import SwiftUI
import AVFoundation

struct Slipper: View {
    private enum PlaybackState: Int {
        case waitingForSelection
        case buffering
        case playing
    }

    let player: AVAudioPlayer
    let timeObserver: TObserver
    let durationObserver: Double

    @State private var currentTime: TimeInterval = 0
 //   @State private var currentDuration: TimeInterval = 0
    @State private var state = PlaybackState.waitingForSelection

    var body: some View {
        VStack {

            Slider(value: $currentTime,
                   in: 0...durationObserver,
                  // onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\((currentTime))"),
                   maximumValueLabel: Text("\(durationObserver))")) {
                    // I have no idea in what scenario this View is shown...
                    Text("seek/progress slider")
            }
            .disabled(state != .playing)
        }
        .padding()
        // Listen out for the time observer publishing changes to the player's time
        .onReceive(timeObserver.publisher) { time in
            // Update the local var
            self.currentTime = time
            // And flag that we've started playback
            if time > 0 {
                self.state = .playing
            }
        }
        // Listen out for the duration observer publishing changes to the player's item
    }
}

//    // MARK: Private functions
//    private func sliderEditingChanged(editingStarted: Bool) {
//        if editingStarted {
//            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
//            // with the slider (otherwise it would keep jumping from where they've moved it to, back
//            // to where the player is currently at)
//            timeObserver.pause(true)
//        }
//        else {
//            // Editing finished, start the seek
//            state = .buffering
//            let targetTime = CMTime(seconds: currentTime,
//                                    preferredTimescale: 600)
//        //    player.seek(to: targetTime) { _ in
//                // Now the (async) seek is completed, resume normal operation
//                self.timeObserver.pause(false)
//                self.state = .playing
//            }
//        }
//    }
//}
