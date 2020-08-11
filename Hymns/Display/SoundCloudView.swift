import SwiftUI

struct SoundCloudView: View {

    @Binding private var dialogModel: DialogViewModel<AnyView>?
    @Binding private var soundCloudPlayer: SoundCloudPlayerViewModel?

    @ObservedObject private var viewModel: SoundCloudViewModel

    init(dialogModel: Binding<DialogViewModel<AnyView>?>,
         soundCloudPlayer: Binding<SoundCloudPlayerViewModel?>,
         viewModel: SoundCloudViewModel) {
        self._dialogModel = dialogModel
        self._soundCloudPlayer = soundCloudPlayer
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        self.dialogModel = nil
                    }, label: {
                        Text("Close").padding()
                    })
                    Spacer()
                    Image("soundcloud_banner")
                    Spacer()
                    if viewModel.showMinimizeCaret {
                        Button(action: {
                            self.soundCloudPlayer = SoundCloudPlayerViewModel(dialogModel: self.$dialogModel)
                            self.dialogModel?.opacity = 0
                        }, label: {
                            Image(systemName: "chevron.down").accessibility(label: Text("Minimize SoundCloud")).padding(.horizontal)
                        }).transformAnchorPreference(key: ToolTipPreferenceKey.self,
                                                     value: .bounds,
                                                     transform: { (value: inout ToolTipPreferenceData, anchor: Anchor<CGRect>) in
                                                        value.indicatorAnchor = anchor
                        })
                    }
                }
                SoundCloudWebView(viewModel: viewModel)
            }
            ToolTipView(tapAction: {})
                .transformAnchorPreference(key: ToolTipPreferenceKey.self,
                                           value: .bounds,
                                           transform: { (value: inout ToolTipPreferenceData, anchor: Anchor<CGRect>) in
                                            value.toolTipAnchor = anchor
                }).opacity(0) // Create an invisible tool tip view in order to calculate the size.
        }.overlayPreferenceValue(ToolTipPreferenceKey.self) { toolTipPreferenceData in
            if self.viewModel.showMinimizeToolTip {
                GeometryReader { geometry in
                    self.createToolTip(geometry, toolTipPreferenceData)
                }
            }
        }
    }

    func createToolTip(_ geometry: GeometryProxy, _ data: ToolTipPreferenceData) -> some View {
        guard let toolTipAnchor = data.toolTipAnchor, let indicatorAnchor = data.indicatorAnchor else {
            return EmptyView().eraseToAnyView()
        }

        let toolTipSize = geometry[toolTipAnchor].size
        let indicatorPoint = geometry[indicatorAnchor]
        return
            ToolTipView(tapAction: {
                self.viewModel.dismissToolTip()
            }).background(ToolTip(cornerRadius: 10,
                                  toolTipMidX: toolTipSize.width - (indicatorPoint.maxX - indicatorPoint.minX)/2 + 7,
                                  toolTipHeight: 7).fill(Color.blue))
                .offset(x: indicatorPoint.maxX - toolTipSize.width - 7, y: indicatorPoint.maxY + 7)
                .eraseToAnyView()
    }
}

struct ToolTipView: View {

    let tapAction: () -> Void

    var body: some View {
        Button(action: {
            self.tapAction()
        }, label: {
            HStack(alignment: .center, spacing: CGFloat.zero) {
                Image(systemName: "xmark").padding()
                Text("Tap to keep playing song in background").font(.caption).padding(.trailing)
            }.foregroundColor(.white)
        })
    }
}

struct ToolTipPreferenceData {

    /**
     * Anchor of the tool tip itself.
     */
    var toolTipAnchor: Anchor<CGRect>?

    /**
     * Anchor that we want the tool tip to point to.
     */
    var indicatorAnchor: Anchor<CGRect>?
}

struct ToolTipPreferenceKey: PreferenceKey {
    static var defaultValue: ToolTipPreferenceData = ToolTipPreferenceData()

    static func reduce(value: inout ToolTipPreferenceData, nextValue: () -> ToolTipPreferenceData) {
        if let toolTipAnchor = nextValue().toolTipAnchor {
            value.toolTipAnchor = toolTipAnchor
        }

        if let indicatorAnchor = nextValue().indicatorAnchor {
            value.indicatorAnchor = indicatorAnchor
        }
    }
}

#if DEBUG
struct SoundCloudView_Previews: PreviewProvider {
    static var previews: some View {
        let searchPathViewModel = SoundCloudViewModel(url: URL(string: "https://soundcloud.com/search/path")!)
        let serachPath = SoundCloudView(dialogModel: .constant(nil), soundCloudPlayer: .constant(nil), viewModel: searchPathViewModel)

        let nonSearchPathViewModel = SoundCloudViewModel(url: URL(string: "https://soundcloud.com/anthonyjohntunes/broken-vessels-amazing-grace-hillsong-live-cover")!)
        let nonSearchPath = SoundCloudView(dialogModel: .constant(nil), soundCloudPlayer: .constant(nil), viewModel: nonSearchPathViewModel)
        return
            Group {
                serachPath.previewDisplayName("search path")
                nonSearchPath.previewDisplayName("non search path")
        }
    }
}
#endif
