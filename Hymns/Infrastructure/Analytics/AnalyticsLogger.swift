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
            DisplaySong.Params.hymn_identifier.rawValue: String(describing: hymnIdentifier)
        ])
    }

    func logDisplayMusicPDF(url: URL) {
        Analytics.logEvent(DisplayMusicPDF.name, parameters: [
            DisplayMusicPDF.Params.pdf_url.rawValue: url.absoluteString
        ])
    }

    /**
     * Log when an error ocurred but is not a fatal error but may happen frequently enough that we don't to
     * log it as a Crashlytics non-fatal.
     * https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=ios#log-excepts
     */
    func logError(message: String, error: Error? = nil, extraParameters: [String: String]? = nil) {
        var parameters: [String: String] = [NonFatalEvent.Params.message.rawValue: message]
        if let error = error {
            parameters[NonFatalEvent.Params.error.rawValue] = error.localizedDescription
        }
        if let extraParameters = extraParameters {
            parameters.merge(extraParameters) { (current, _) in current }
        }
        Analytics.logEvent(NonFatalEvent.name, parameters: parameters)
    }
}
