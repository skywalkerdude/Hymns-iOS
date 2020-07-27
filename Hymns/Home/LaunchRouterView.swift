import Resolver
import SwiftUI

struct LaunchRouterView: View {

    private let userDefaultsManager: UserDefaultsManager

    @State var showSplashAnimation: Bool {
        willSet {
            userDefaultsManager.showSplashAnimation = newValue
        }
    }

    init(userDefaultsManager: UserDefaultsManager = Resolver.resolve()) {
        self.userDefaultsManager = userDefaultsManager
        self._showSplashAnimation = .init(initialValue: userDefaultsManager.showSplashAnimation)
    }

    var body: some View {
        Group { () -> AnyView in
            if showSplashAnimation {
                return SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                            self.showSplashAnimation = false
                        }
                }.eraseToAnyView()
            } else {
                return HomeContainerView().eraseToAnyView()
            }
        }
    }
}
