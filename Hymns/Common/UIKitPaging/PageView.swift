import SwiftUI

struct PageView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @State var currentPage = 0


    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }

    var body: some View {
        VStack {
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
            Text("Current Page: \(currentPage)")
        }
    }
}

struct PageView_Previews: PreviewProvider {

    static private let classic1151preview = DisplayHymnView( viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
    static private let classic1334preview = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334))

    static var previews: some View {
        PageView([classic1151preview, classic1334preview ])
            .aspectRatio(3/2, contentMode: .fit)
    }
}
