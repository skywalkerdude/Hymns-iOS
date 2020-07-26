import SwiftUI

struct LaunchRouterView: View {
    @State var showSplash: Bool = false

    var body: some View {
        Group { () -> AnyView in
            if showSplash {
                return SplashScreenView()
                    .opacity(showSplash ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                            self.showSplash = false
                        }
                }.eraseToAnyView()
            } else {
                return HomeContainerView().eraseToAnyView()
            }
        }.onAppear {
            if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
                UserDefaults.standard.set(true, forKey: "didLaunchBefore")
                self.showSplash = true
            }
        }
    }
}
