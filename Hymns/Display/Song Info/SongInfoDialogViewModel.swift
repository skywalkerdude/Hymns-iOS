import Foundation
import Combine
import RealmSwift
import Resolver
import SwiftUI

class SongInfoDialogViewModel: ObservableObject {

    @Published var songInfo = [SongInfoViewModel]()

    private let backgroundQueue: DispatchQueue
    private let identifier: HymnIdentifier
    private let mainQueue: DispatchQueue
    private let repository: HymnsRepository

    private var disposables = Set<AnyCancellable>()

    init(backgroundQueue: DispatchQueue = Resolver.resolve(name: "background"),
         hymnToDisplay identifier: HymnIdentifier,
         hymnsRepository repository: HymnsRepository = Resolver.resolve(),
         mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.backgroundQueue = backgroundQueue
        self.identifier = identifier
        self.mainQueue = mainQueue
        self.repository = repository
    }

    func fetchSongInfo() {
        repository
            .getHymn(identifier)
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] hymn in
                    guard let self = self else { return }
                    guard let hymn = hymn else { return }

                    if let category = hymn.category, !category.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Category", compositeValue: category))
                    }
                    if let subcategory = hymn.subcategory, !subcategory.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Subcategory", compositeValue: subcategory))
                    }
                    if let author = hymn.author, !author.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Author", compositeValue: author))
                    }
            }).store(in: &disposables)
    }

    private func createSongInfoViewModel(label: String, compositeValue: String) -> SongInfoViewModel {
        let values = compositeValue.components(separatedBy: ";").compactMap { value -> String? in
            guard !value.trim().isEmpty else {
                return nil
            }
            return value
        }
        return SongInfoViewModel(label: label, values: values)
    }
}

extension SongInfoDialogViewModel: Equatable {
    static func == (lhs: SongInfoDialogViewModel, rhs: SongInfoDialogViewModel) -> Bool {
        lhs.identifier == rhs.identifier
    }
}
