import SwiftUI

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-views-in-a-loop-using-foreach
struct PagerView<Content: View>: View {

    /**
     * Offset required for a page change to occur.
     */
    private let pageChangeOffset: CGFloat = 0.3

    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    @GestureState private var translation: CGFloat = 0

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let thresholdHit = abs(offset) > self.pageChangeOffset
                    if !thresholdHit {
                        return
                    }
                    let newIndex = self.currentIndex + (offset > 0 ? -1 : 1)
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        var page = 0
        let currentPageBinding = Binding<Int>(
            get: {page},
            set: {page = $0})
        return PagerView(pageCount: 300, currentIndex: currentPageBinding) {
            ForEach(1..<100) { _ in
                Color.blue
                Color.red
                Color.green
            }
        }
    }
}
