import Combine
import Foundation
import Resolver

class DisplayHymnContainerViewModel: ObservableObject {

    private(set) var hymns: [DisplayHymnView]
    @Published var currentIndex: Int

    private var disposables = Set<AnyCancellable>()

    private let hymnIdentifier: HymnIdentifier

    init(hymnToDisplay hymnIdentifier: HymnIdentifier, mainQueue: DispatchQueue = Resolver.resolve(name: "main")) {
        self.hymnIdentifier = hymnIdentifier

        if !hymnIdentifier.isContinuous {
            currentIndex = 0
            hymns = [DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: hymnIdentifier))]
            return
        }

        currentIndex = (Int(hymnIdentifier.hymnNumber) ?? 1) - 1
        hymns = [DisplayHymnView]()
        for hymnNumber in 1...hymnIdentifier.hymnType.maxNumber {
            hymns.append(
                DisplayHymnView(viewModel:
                    DisplayHymnViewModel(hymnToDisplay:
                        HymnIdentifier(hymnType: hymnIdentifier.hymnType, hymnNumber: "\(hymnNumber)", queryParams: hymnIdentifier.queryParams))))
        }

        $currentIndex
            .receive(on: mainQueue)
            .sink { currentIndex in
                for index in self.hymns.indices {
                    if index >= currentIndex - 1 && index <= currentIndex + 1 {
                        self.hymns[index].viewModel.isLoaded = true
                    } else {
                        self.hymns[index].viewModel.isLoaded = false
                    }
                }
        }.store(in: &disposables)
    }
}
