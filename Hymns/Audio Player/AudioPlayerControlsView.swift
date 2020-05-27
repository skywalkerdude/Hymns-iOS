import AVFoundation
import SwiftUI

struct AudioPlayerControlsView: View {

    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    @Binding var currentlyPlaying: Bool
    @State private var currentTime: TimeInterval = 0

    var body: some View {
        VStack {
            Slider(value: $currentTime,
                   in: 0...60,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text("\(Utility.formatSecondsToHMS(currentTime))"),
                   maximumValueLabel: Text("")) {
                    // I have no idea in what scenario this View is shown...
                    Text("seek/progress slider")
            }
            .disabled(currentlyPlaying != true)
        }
        .padding()
            // Listen out for the time observer publishing changes to the player's time
            .onReceive(timeObserver.publisher) { time in
                // Update the local var
                self.currentTime = time
                // And flag that we've started playback
                if time > 0 {
                    self.currentlyPlaying = true
                }
        }
    }

    // MARK: Private functions
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            timeObserver.pause(true)
        } else {
            // Editing finished, start the seek
            currentlyPlaying = false
            let targetTime = CMTime(seconds: currentTime,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
                self.currentlyPlaying = true
            }
        }
    }
}
