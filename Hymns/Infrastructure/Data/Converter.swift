import Foundation
import Resolver

protocol Converter {
    func toHymnEntity(hymnIdentifier: HymnIdentifier, hymn: Hymn) throws -> HymnEntity
    func toUiHymn(hymnIdentifier: HymnIdentifier, hymnEntity: HymnEntity?) throws -> UiHymn?
    func toSongResultEntities(songResultsPage: SongResultsPage) -> ([SongResultEntity], Bool)
    func toUiSongResultsPage(songResultsEntities: [SongResultEntity], hasMorePages: Bool) -> UiSongResultsPage
}

class ConverterImpl: Converter {

    private let analytics: AnalyticsLogger
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(analytics: AnalyticsLogger = Resolver.resolve(),
         jsonDecoder: JSONDecoder = Resolver.resolve(),
         jsonEncoder: JSONEncoder = Resolver.resolve()) {
        self.analytics = analytics
        self.jsonDecoder = jsonDecoder
        self.jsonEncoder = jsonEncoder
    }

    func toHymnEntity(hymnIdentifier: HymnIdentifier, hymn: Hymn) throws -> HymnEntity {
        let title = hymn.title
        let lyricsJson = try jsonEncoder.encode(hymn.lyrics).toString
        let category = getMetadata(hymn: hymn, metaDatumName: .category)
        let subCategory = getMetadata(hymn: hymn, metaDatumName: .subcategory)
        let author = getMetadata(hymn: hymn, metaDatumName: .author)
        let composer = getMetadata(hymn: hymn, metaDatumName: .composer)
        let key = getMetadata(hymn: hymn, metaDatumName: .key)
        let time = getMetadata(hymn: hymn, metaDatumName: .time)
        let meter = getMetadata(hymn: hymn, metaDatumName: .meter)
        let hymnCode = getMetadata(hymn: hymn, metaDatumName: .hymnCode)
        let scriptures = getMetadata(hymn: hymn, metaDatumName: .scriptures)
        let musicJson = hymn.getMetaDatum(name: .music) != nil ? try? jsonEncoder.encode(hymn.getMetaDatum(name: .music)).toString : nil
        let svgSheetJson = hymn.getMetaDatum(name: .svgSheet) != nil ? try? jsonEncoder.encode(hymn.getMetaDatum(name: .svgSheet)).toString : nil
        let pdfSheetJson = hymn.getMetaDatum(name: .pdfSheet) != nil ? try? jsonEncoder.encode(hymn.getMetaDatum(name: .pdfSheet)).toString : nil
        let languagesJson = hymn.getMetaDatum(name: .languages) != nil ? try? jsonEncoder.encode(hymn.getMetaDatum(name: .languages)).toString : nil
        let relevantJson = hymn.getMetaDatum(name: .relevant) != nil ? try? jsonEncoder.encode(hymn.getMetaDatum(name: .relevant)).toString : nil
        return HymnEntity(hymnIdentifier: hymnIdentifier,
                          title: title,
                          lyricsJson: lyricsJson,
                          category: category,
                          subcategory: subCategory,
                          author: author,
                          composer: composer,
                          key: key,
                          time: time,
                          meter: meter,
                          scriptures: scriptures,
                          hymnCode: hymnCode,
                          musicJson: musicJson,
                          svgSheetJson: svgSheetJson,
                          pdfSheetJson: pdfSheetJson,
                          languagesJson: languagesJson,
                          relevantJson: relevantJson)
    }

    private func getMetadata(hymn: Hymn, metaDatumName: MetaDatumName) -> String? {
        guard let metaDatum = hymn.getMetaDatum(name: metaDatumName) else {
            return nil
        }

        var databaseValue = ""
        for (index, datum) in metaDatum.data.enumerated() {
            if datum.value.isEmpty {
                continue
            }
            databaseValue += datum.value
            if index < metaDatum.data.count - 1 {
                databaseValue += ""
            }
        }
        return databaseValue.trim()
    }

    func toUiHymn(hymnIdentifier: HymnIdentifier, hymnEntity: HymnEntity?) throws -> UiHymn? {
        guard let hymnEntity = hymnEntity else {
            return nil
        }

        guard let lyrics = hymnEntity.lyricsJson, !lyrics.isEmpty, let lyricsData = lyrics.data(using: .utf8) else {
            throw TypeConversionError(triggeringError: ErrorType.parsing(description: "lyrics json was empty"))
        }

        guard let title = hymnEntity.title?.replacingOccurrences(of: "Hymn: ", with: ""), !title.isEmpty else {
            throw TypeConversionError(triggeringError: ErrorType.parsing(description: "title was empty"))
        }

        let category = hymnEntity.category
        let subcategory = hymnEntity.subcategory
        let author = hymnEntity.author
        let composer = hymnEntity.composer
        let key = hymnEntity.key
        let time = hymnEntity.time
        let meter = hymnEntity.meter
        let scriptures = hymnEntity.scriptures
        let hymnCode = hymnEntity.hymnCode

        let pdfSheet: MetaDatum?
        if let pdfData = hymnEntity.pdfSheetJson?.data(using: .utf8) {
            pdfSheet = try? jsonDecoder.decode(MetaDatum.self, from: pdfData)
        } else {
            pdfSheet = nil
        }

        let music: MetaDatum?
         if let musicData = hymnEntity.musicJson?.data(using: .utf8) {
             music = try? jsonDecoder.decode(MetaDatum.self, from: musicData)
         } else {
             music = nil
         }

        let languages: MetaDatum?
        if let languagesData = hymnEntity.languagesJson?.data(using: .utf8) {
            languages = try? jsonDecoder.decode(MetaDatum.self, from: languagesData)
        } else {
            languages = nil
        }

        let relevant: MetaDatum?
        if let relevantData = hymnEntity.relevantJson?.data(using: .utf8) {
            relevant = try? jsonDecoder.decode(MetaDatum.self, from: relevantData)
        } else {
            relevant = nil
        }

        do {
            let verses = try jsonDecoder.decode([Verse].self, from: lyricsData)
            return UiHymn(hymnIdentifier: hymnIdentifier, title: title, lyrics: verses, pdfSheet: pdfSheet,
                          category: category, subcategory: subcategory, author: author, composer: composer,
                          key: key, time: time, meter: meter, scriptures: scriptures, hymnCode: hymnCode,
                          languages: languages, music: music, relevant: relevant)
        } catch {
            throw TypeConversionError(triggeringError: error)
        }
    }

    func toSongResultEntities(songResultsPage: SongResultsPage) -> ([SongResultEntity], Bool) {
        let songResultEntities = songResultsPage.results.compactMap { songResult -> SongResultEntity? in
            guard let hymnType = RegexUtil.getHymnType(path: songResult.path), let hymnNumber = RegexUtil.getHymnNumber(path: songResult.path) else {
                self.analytics.logError(message: "error happened when trying to parse song result", extraParameters: ["path": songResult.path, "name": songResult.name])
                return nil
            }
            let queryParams = RegexUtil.getQueryParams(path: songResult.path)
            let title = songResult.name
            return SongResultEntity(hymnType: hymnType, hymnNumber: hymnNumber, queryParams: queryParams, title: title)
        }
        return (songResultEntities, songResultsPage.hasMorePages ?? false)
    }

    func toUiSongResultsPage(songResultsEntities: [SongResultEntity], hasMorePages: Bool) -> UiSongResultsPage {
        let songResults = songResultsEntities.map { songResultsEntity -> UiSongResult in
            let title = songResultsEntity.title
            let hymnType = songResultsEntity.hymnType
            let hymnNumber = songResultsEntity.hymnNumber
            let queryParams = songResultsEntity.queryParams
            let hymnIdentifier = HymnIdentifier(hymnType: hymnType, hymnNumber: hymnNumber, queryParams: queryParams)
            return UiSongResult(name: title, identifier: hymnIdentifier)
        }
        return UiSongResultsPage(results: songResults, hasMorePages: hasMorePages)
    }
}

extension Resolver {
    static func registerConverters() {
        register {ConverterImpl() as Converter}.scope(application)
    }
}
