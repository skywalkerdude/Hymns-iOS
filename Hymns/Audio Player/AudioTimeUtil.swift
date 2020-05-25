import Foundation
import AVFoundation

class Utility: NSObject {

    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()

    static func formatSecondsToHMS(_ seconds: Double) -> String {
        return timeHMSFormatter.string(from: seconds) ?? "00:00"
    }

    static func convertFloatToCMTime(_ floatTime: Float64) -> CMTime {
        CMTimeMake(value: Int64(floatTime * 1000 as Float64), timescale: 1000)
    }
}
