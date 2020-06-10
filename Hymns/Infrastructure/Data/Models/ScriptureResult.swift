struct ScriptureResult: Equatable {
    typealias Chapter = String
    typealias Verse = String

    let hymnIdentifier: HymnIdentifier
    let title: String
    let book: Book
    let chapter: Chapter?
    let verse: Verse?
}
