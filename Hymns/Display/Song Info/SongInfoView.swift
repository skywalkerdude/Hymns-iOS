import SwiftUI

struct SongInfoView: View {

    @ObservedObject var viewModel: SongInfoViewModel

    var body: some View {
        HStack {
            Text(viewModel.label).font(.callout).bold()
            VStack(alignment: .leading) {
                ForEach(viewModel.values, id: \.self) { value in
                    Text(value).font(.callout)
                }
            }
        }
    }
}

#if DEBUG
struct SongInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SongInfoViewModel(label: "Category", values: ["Worship of the Father", "The Son's Redemption"])
        return Group {
            SongInfoView(viewModel: viewModel).toPreviews()
        }
    }
}
#endif
