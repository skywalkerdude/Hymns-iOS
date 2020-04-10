import SwiftUI

struct SongResultView<DestinationView>: View where DestinationView: View {

    private let viewModel: SongResultViewModel<DestinationView>

    var body: some View {
        Text(viewModel.title)
    }

    init(viewModel: SongResultViewModel<DestinationView>) {
        self.viewModel = viewModel
    }
}

struct SongResultView_Previews: PreviewProvider {
    static var previews: some View {
        SongResultView(viewModel: SongResultViewModel(title: "Hymn 480",
                                                      destinationView: Text("Destination")))
            .previewLayout(.fixed(width: 200, height: 50))
    }
}
