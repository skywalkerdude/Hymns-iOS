import AVFoundation
import SwiftUI

/**
 * Sliider/scrubber for the audio player.
 */
struct AudioSlider: View {

    let player: AVPlayer
    let timeObserver: PlayerTimeObserver
    @Binding var currentlyPlaying: Bool
    @State private var currentTime: TimeInterval = 0

    var body: some View {
        Slider(value: $currentTime,
               in: 0...60,
               onEditingChanged: sliderEditingChanged,
               minimumValueLabel: Text("\(formatSecondsToHMS(currentTime))"),
               maximumValueLabel: Text(""),
               label: {
                Text("Song progress slider")
        }) // Listen for the time observer publishing changes to the player's time
            .onReceive(timeObserver.publisher) { time in
                // Update the time
                self.currentTime = time
        }.padding()
    }

    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            timeObserver.pause(true)
        } else {
            // Editing finished, start the seek
            currentlyPlaying = false
            let targetTime = CMTime(seconds: currentTime, preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                self.timeObserver.pause(false)
                self.currentlyPlaying = true
            }
        }
    }

    private func formatSecondsToHMS(_ seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: seconds) ?? "00:00"
    }
}

#if DEBUG
struct AudioPlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {

        var bool: Bool = true
        let currentlyPlaying = Binding<Bool>(
            get: {bool},
            set: {bool = $0})
        let avPlayer = AVPlayer()
        let observer = PlayerTimeObserver(player: AVPlayer())
        return Group {
            AudioSlider(player: avPlayer, timeObserver: observer, currentlyPlaying: currentlyPlaying)
        }
    }
}
#endif
