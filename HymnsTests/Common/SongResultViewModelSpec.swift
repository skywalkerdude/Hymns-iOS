import Combine
import Mockingbird
import Nimble
import Quick
import SwiftUI
@testable import Hymns

class SongResultViewModelSpec: QuickSpec {

    override func spec() {
        describe("equals") {
            it("should be equal if they are the same object") {
                let viewModel = SongResultViewModel(title: "title 1", destinationView: EmptyView().eraseToAnyView())
                expect(viewModel).to(equal(viewModel))
            }
            it("should be equal if they have the same title") {
                let viewModel1 = SongResultViewModel(title: "title 1", destinationView: EmptyView().eraseToAnyView())
                let viewModel2 = SongResultViewModel(title: "title 1", destinationView: Text("different view").eraseToAnyView())
                expect(viewModel1).to(equal(viewModel2))
            }
            it("should be not be equal if they have the different titles") {
                let viewModel1 = SongResultViewModel(title: "title 1", destinationView: EmptyView().eraseToAnyView())
                let viewModel2 = SongResultViewModel(title: "title 2", destinationView: EmptyView().eraseToAnyView())
                expect(viewModel1).toNot(equal(viewModel2))
            }
        }

        describe("hasher") {
            it("hashes only the title") {
                let viewModel = SongResultViewModel(title: "title 1", destinationView: EmptyView().eraseToAnyView())
                expect(viewModel.hashValue).to(equal("title 1".hashValue))
            }
        }
    }
}
