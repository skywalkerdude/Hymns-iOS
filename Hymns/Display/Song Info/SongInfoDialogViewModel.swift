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
        fetchSongInfo()
    }

    // swiftlint:disable:next cyclomatic_complexity
    func fetchSongInfo() {
        repository
            .getHymn(identifier)
            .subscribe(on: backgroundQueue)
            .receive(on: mainQueue)
            .sink(
                receiveValue: { [weak self] hymn in
                    guard let self = self else { return }
                    guard let hymn = hymn else { return }

                    self.songInfo = [SongInfoViewModel]()
                    if let category = hymn.category, !category.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Category", compositeValue: category))
                    }
                    if let subcategory = hymn.subcategory, !subcategory.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Subcategory", compositeValue: subcategory))
                    }
                    if let author = hymn.author, !author.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Author", compositeValue: author))
                    }
                    if let composer = hymn.composer, !composer.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Composer", compositeValue: composer))
                    }
                    if let key = hymn.key, !key.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Key", compositeValue: key))
                    }
                    if let time = hymn.time, !time.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Time", compositeValue: time))
                    }
                    if let meter = hymn.meter, !meter.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Meter", compositeValue: meter))
                    }
                    if let scriptures = hymn.scriptures, !scriptures.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Scriptures", compositeValue: scriptures))
                    }
                    if let hymnCode = hymn.hymnCode, !hymnCode.isEmpty {
                        self.songInfo.append(self.createSongInfoViewModel(label: "Hymn Code", compositeValue: hymnCode))
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
