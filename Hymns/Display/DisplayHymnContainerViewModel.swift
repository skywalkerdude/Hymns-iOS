import Combine
import Foundation
import Resolver

class DisplayHymnContainerViewModel: ObservableObject {

    @Published var hymns: [DisplayHymnViewModel]
    @Published var currentIndex: Int

    private var disposables = Set<AnyCancellable>()

    private let hymnIdentifier: HymnIdentifier

    init(hymnToDisplay hymnIdentifier: HymnIdentifier, mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.hymnIdentifier = hymnIdentifier

        if !hymnIdentifier.isContinuous {
            currentIndex = 0
            hymns = [DisplayHymnViewModel(hymnToDisplay: hymnIdentifier)]
            return
        }

        currentIndex = (Int(hymnIdentifier.hymnNumber) ?? 1) - 1
        hymns = [DisplayHymnViewModel]()
        for hymnNumber in 1...hymnIdentifier.hymnType.maxNumber {
            hymns.append(
                DisplayHymnViewModel(hymnToDisplay:
                    HymnIdentifier(hymnType: hymnIdentifier.hymnType, hymnNumber: "\(hymnNumber)", queryParams: hymnIdentifier.queryParams)))
        }

        $currentIndex
            .receive(on: mainQueue)
            .sink { currentIndex in
                for index in self.hymns.indices {
                    if index >= currentIndex - 1 && index <= currentIndex + 1 {
                        self.hymns[index].isLoaded = true
                    } else {
                        self.hymns[index].isLoaded = false
                    }
                }
        }.store(in: &disposables)
    }
}
