import SwiftUI

struct LaunchRouterView: View {
    @State var showSplash: Bool = FirstLaunch.showSplash

    var body: some View {
        Group { () -> AnyView in
            if showSplash {
                FirstLaunch.showSplash = false
                return SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                            self.showSplash = false
                        }
                }.eraseToAnyView()
            } else {
                return HomeContainerView().eraseToAnyView()
            }
        }
    }
}
