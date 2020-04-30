import SwiftUI

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-views-in-a-loop-using-foreach
struct PagerView<Content: View>: View {

    /**
     * Offset required for a page change to occur.
     */
    private let pageChangeOffset: CGFloat = 0.3

    let pageCount: Int
    @Binding var currentIndex: Int
    let viewBuilder: (_ page: Int) -> Content

    @GestureState private var translation: CGFloat = 0

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: @escaping (_ page: Int) -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.viewBuilder = content
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.doIt(geometry).frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
//            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
                // TODO this thing gotta be not 0 all the time
                .offset(x: -CGFloat(self.figureOut()) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    print("offset: \(offset)")
                    let thresholdHit = abs(offset) > self.pageChangeOffset
                    if !thresholdHit {
                        return
                    }
                    let newIndex = self.currentIndex + (offset > 0 ? -1 : 1)
                    print("newIndex: \(newIndex)")
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                    print("self.currentIndex = min(max(Int(\(newIndex)), 0), \(self.pageCount) - 1) = \(self.currentIndex)")
                }
            )
        }
    }

    func doIt(_ geometry: GeometryProxy) -> ForEach<Range<Int>, Int, Content> {
        var items = [Int]()
        if self.currentIndex != 0 {
            items.append(-1)
        }
        items.append(0)
        if self.currentIndex < self.pageCount {
            items.append(1)
        }
        print("currentIndex: \(currentIndex) items: \([items])")
        return ForEach(items.indices, id: \.self) { idx in
            self.dodo(items[idx])
        }
    }

    func dodo(_ idx: Int) -> Content {
        print("currentIndex: \(self.currentIndex) idx: \(idx)")
        return self.viewBuilder(self.currentIndex + idx)
    }

    func figureOut() -> Int {
        if self.currentIndex == 0 {
            return 0
        }
        return 1
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        var page = 3
        let currentPageBinding = Binding<Int>(
            get: {page},
            set: {page = $0})

        var colors = [Color]()
        for num in 1...50 {
            colors.append(.blue)
            colors.append(.green)
            colors.append(.red)
        }

        var nums = [Int]()
        for num in 1...300 {
            nums.append(num)
        }
        return PagerView(pageCount: 50, currentIndex: currentPageBinding) { page in
            VStack {
                Text("page \(nums[page])")
                colors[page]
            }
        }
    }
}
