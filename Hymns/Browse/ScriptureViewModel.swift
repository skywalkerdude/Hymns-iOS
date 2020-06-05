import Foundation

class ScriptureViewModel: ObservableObject {

    let book: Book
    var scriptureSongs: [ScriptureSongViewModel]

    init(book: Book, scriptureSongs: [ScriptureSongViewModel]) {
        self.book = book
        self.scriptureSongs = scriptureSongs
    }
}

extension ScriptureViewModel: Identifiable {
}

extension ScriptureViewModel: Equatable {
    static func == (lhs: ScriptureViewModel, rhs: ScriptureViewModel) -> Bool {
        lhs.book == rhs.book && lhs.scriptureSongs == rhs.scriptureSongs
    }
}

extension ScriptureViewModel: CustomStringConvertible {
    var description: String {
        "\(book): \(scriptureSongs)"
    }
}
