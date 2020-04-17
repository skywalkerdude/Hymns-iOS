import SwiftUI

struct SimpleSettingView: View {

    let viewModel: SimpleSettingViewModel

    var body: some View {
        Button(action: viewModel.action, label: {
            VStack(alignment: .leading, spacing: 5) {
                Text(viewModel.title).font(.callout)
                viewModel.subtitle.map { Text($0).font(.caption) }
            }
        }).padding().foregroundColor(.black)
    }
}

struct SimpleSettingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SimpleSettingView(viewModel: SimpleSettingViewModel(title: "Theme", subtitle: "Using system theme", action: {}))
            SimpleSettingView(viewModel: SimpleSettingViewModel(title: "Privacy Policy", action: {}))
        }.previewLayout(.fixed(width: 400, height: 50))
    }
}
