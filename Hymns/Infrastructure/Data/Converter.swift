import Foundation
import Resolver

protocol Converter {
    func toHymnEntity(hymnIdentifier: HymnIdentifier, hymn: Hymn) throws -> HymnEntity
    func toUiHymn(hymnIdentifier: HymnIdentifier, hymnEntity: HymnEntity?) throws -> UiHymn?
}

class ConverterImpl: Converter {

    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder

    init(jsonDecoder: JSONDecoder = Resolver.resolve(), jsonEncoder: JSONEncoder = Resolver.resolve()) {
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
        return HymnEntity(id: 0,
                          hymnType: hymnIdentifier.hymnType.abbreviatedValue,
                          hymnNumber: hymnIdentifier.hymnNumber,
                          queryParams: hymnIdentifier.queryParamString,
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

        guard let lyrics = hymnEntity.lyricsJson, !lyrics.isEmpty, let data = lyrics.data(using: .utf8) else {
            throw TypeConversionError(triggeringError: ErrorType.parsing(description: "lyrics json was empty"))
        }

        guard let title = hymnEntity.title, !title.isEmpty else {
            throw TypeConversionError(triggeringError: ErrorType.parsing(description: "title was empty"))
        }

        do {
            let verses = try jsonDecoder.decode([Verse].self, from: data)
            return UiHymn(hymnIdentifier: hymnIdentifier, title: title, lyrics: verses)
        } catch {
            throw TypeConversionError(triggeringError: error)
        }
    }
}

extension Resolver {
    static func registerConverters() {
        register {ConverterImpl() as Converter}.scope(application)
    }
}
