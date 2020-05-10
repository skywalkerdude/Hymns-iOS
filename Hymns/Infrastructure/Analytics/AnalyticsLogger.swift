import FirebaseAnalytics
import Foundation

/**
 * Wrapper for `FirebaseAnalytics` to help keep track of what we are logging and analyzing.
 */
class AnalyticsLogger {

    func logSearchActive(isActive: Bool) {
        Analytics.logEvent(SearchActiveChanged.name, parameters: [
            SearchActiveChanged.Params.is_active.rawValue: isActive ? "true" : false
        ])
    }

    func logQueryChanged(queryText: String) {
        Analytics.logEvent(QueryChanged.name, parameters: [
            QueryChanged.Params.query_text.rawValue: queryText
        ])
    }

    func logDisplaySong(hymnIdentifier: HymnIdentifier) {
        Analytics.logEvent(DisplaySong.name, parameters: [
            DisplaySong.Params.hymn_identifier.rawValue: hymnIdentifier
        ])
    }
}
