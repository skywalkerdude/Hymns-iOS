import SwiftUI

public struct ToastOptions {
    var alignment: Alignment = .top
    var timeToShow: TimeInterval?
    var backdrop: Bool

    public init(alignment: Alignment = .top, disappearAfter timeToShow: TimeInterval? = nil, backdrop: Bool = true) {
        self.alignment = alignment
        self.timeToShow = timeToShow
        self.backdrop = backdrop
    }
}

/// https://github.com/sanzaru/SimpleToast
struct SimpleToast<Item, ToastContent>: ViewModifier where Item: Identifiable, ToastContent: View {

    @State private var timer: Timer?
    @State private var offset = CGSize.zero

    @Binding var item: Item?
    let options: ToastOptions
    let completion: (() -> Void)?
    let content: (Item) -> ToastContent

    func body(content: Content) -> some View {
        if item != nil && timer == nil && options.timeToShow != nil {
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.options.timeToShow!, repeats: false) { _ in
                    self.hide()
                }
            }
        }
        return content.overlay(
            item.map { item in
                self.content(item)
                    .offset(x: 0, y: offset.height)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray).opacity(0.6))
                            .opacity(options.backdrop ? 1 : 0)
                            .blur(radius: 20))
                    .gesture(TapGesture().onEnded { self.hide() })
        }, alignment: options.alignment)
    }

    private func hide() {
        withAnimation {
            self.timer?.invalidate()
            self.timer = nil
            self.offset = .zero
            self.item = nil

            self.completion.map { callback in
                callback()
            }
        }
    }
}

extension View {
    public func toast<Item, ToastContent>(item: Binding<Item?>, options: ToastOptions = ToastOptions(),
                                          completion: (() -> Void)? = nil,
                                          content: @escaping (Item) -> ToastContent) -> some View where Item: Identifiable, ToastContent: View {
        self.modifier(
            SimpleToast(item: item, options: options, completion: completion, content: content)
        )
    }
}
