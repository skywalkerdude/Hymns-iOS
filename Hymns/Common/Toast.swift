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
                    .maxWidth(alignment: .leading)
                    .background(options.backdrop ? Color(.tertiarySystemBackground) : .clear)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
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

#if DEBUG
struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        let top =
            Text("__PREVIEW__ Content here")
                .maxSize()
                .toast(item: .constant(TagColor.blue), options: ToastOptions(alignment: .top)) { _ -> AnyView in
                    Text("__PREVIEW__ Toast text").padding()
                        .eraseToAnyView()
        }
        let center =
            Text("__PREVIEW__ Content here")
                .maxSize()
                .toast(item: .constant(TagColor.blue), options: ToastOptions(alignment: .center)) { _ -> AnyView in
                    VStack {
                        Text("__PREVIEW__ Toast line 1")
                        Text("__PREVIEW__ Toast line 2")
                    }.padding()
                        .eraseToAnyView()
        }
        let bottom =
            Text("__PREVIEW__ Content here")
                .maxSize()
                .toast(item: .constant(TagColor.blue), options: ToastOptions(alignment: .bottom)) { _ -> AnyView in
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(.green).padding()
                        Text("__PREVIEW__ Toast text").padding(.trailing)
                    }
                    .eraseToAnyView()
        }
        let bottomWithOutBackdrop =
            Text("__PREVIEW__ Content here")
                .maxSize()
                .toast(item: .constant(TagColor.blue), options: ToastOptions(alignment: .bottom, backdrop: false)) { _ -> AnyView in
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(.green).padding()
                        Text("__PREVIEW__ Toast text").padding(.trailing)
                    }
                    .eraseToAnyView()
        }
        let darkMode =
            Text("__PREVIEW__ Content here")
                .maxSize()
                .toast(item: .constant(TagColor.blue), options: ToastOptions(alignment: .bottom)) { _ -> AnyView in
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(.green).padding()
                        Text("__PREVIEW__ Toast text").padding(.trailing)
                    }
                    .eraseToAnyView()
            }.background(Color(.systemBackground)).environment(\.colorScheme, .dark)
        let darkModeWithoutBackdrop =
            Text("__PREVIEW__ Content here")
                .maxSize()
                .toast(item: .constant(TagColor.blue), options: ToastOptions(alignment: .bottom, backdrop: false)) { _ -> AnyView in
                    HStack {
                        Image(systemName: "checkmark").foregroundColor(.green).padding()
                        Text("__PREVIEW__ Toast text").padding(.trailing)
                    }
                    .eraseToAnyView()
            }.background(Color(.systemBackground)).environment(\.colorScheme, .dark)
        return Group {
            top.previewDisplayName("top")
            center.previewDisplayName("center")
            bottom.previewDisplayName("bottom")
            bottomWithOutBackdrop.previewDisplayName("bottom without backdrop")
            darkMode.previewDisplayName("dark mode")
            darkModeWithoutBackdrop.previewDisplayName("dark mode without backdrop")
        }
    }
}
#endif

extension View {
    public func toast<Item, ToastContent>(item: Binding<Item?>, options: ToastOptions = ToastOptions(),
                                          completion: (() -> Void)? = nil,
                                          content: @escaping (Item) -> ToastContent) -> some View where Item: Identifiable, ToastContent: View {
        self.modifier(
            SimpleToast(item: item, options: options, completion: completion, content: content)
        )
    }
}
