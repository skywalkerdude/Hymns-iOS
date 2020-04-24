import SwiftUI

struct PagerView<Content: View>: View {
    @Binding var currentIndex: Int
    let content: Content

    init(currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._currentIndex = currentIndex
        self.content = content()
    }

    @GestureState private var translation: CGFloat = 0
    @State var newIndex: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(abs(self.currentIndex)) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    self.newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    if self.currentIndex >= 0 {
                        self.currentIndex = Int(self.newIndex)
                        print("current index")

                        print(String(self.currentIndex))
                        print("new index")

                        print(self.newIndex)
                    } else {
                        self.currentIndex = Int(self.newIndex)
                        print("current index")
                        print(String(self.currentIndex))
                        print("new index")
                        print(self.newIndex)
                    }
                }
            )
        }
    }
}

func fetchNum(stringHymnNumber: String, index: Int) -> String {
    var hymnIndex = Int(stringHymnNumber) ?? 0
    hymnIndex += index
    let stringed = String(hymnIndex)
    return(stringed)
}
struct Pager: View {
    @ObservedObject var viewModel: DisplayHymnViewModel

    @State private var currentPage = 0
    let classic1151View = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
    let classic1334View = DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1334))

    var body: some View {
        PagerView(currentIndex: $currentPage) {
            DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: HymnIdentifier(hymnType: .classic, hymnNumber: fetchNum(stringHymnNumber: self.viewModel.identifier.hymnNumber, index: self.currentPage))))
            DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: HymnIdentifier(hymnType: .classic, hymnNumber: fetchNum(stringHymnNumber: self.viewModel.identifier.hymnNumber, index: self.currentPage))))
            DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: HymnIdentifier(hymnType: .classic, hymnNumber: fetchNum(stringHymnNumber: self.viewModel.identifier.hymnNumber, index: self.currentPage))))
            DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: HymnIdentifier(hymnType: .classic, hymnNumber: fetchNum(stringHymnNumber: self.viewModel.identifier.hymnNumber, index: self.currentPage))))
            DisplayHymnView(viewModel: DisplayHymnViewModel(hymnToDisplay: HymnIdentifier(hymnType: .classic, hymnNumber: fetchNum(stringHymnNumber: self.viewModel.identifier.hymnNumber, index: self.currentPage))))
        }.onAppear {
            print("\(self.viewModel.identifier.hymnNumber)")
        }
    }
}

struct Pager_Previews: PreviewProvider {
    static var previews: some View {
        Pager(viewModel: DisplayHymnViewModel(hymnToDisplay: PreviewHymnIdentifiers.hymn1151))
    }
}
