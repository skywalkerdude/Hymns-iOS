import SwiftUI

struct PagerView<Page: View>: View {
    var viewControllers: [UIHostingController<Page>]
    @Binding var currentPage: Int

    init(currentPage: Binding<Int>, _ pages: [Page]) {
        self._currentPage = currentPage
        self.viewControllers = pages.map { UIHostingController(rootView: $0) }
    }

    var body: some View {
        PageViewController(controllers: viewControllers, currentPage: $currentPage)
    }
}
