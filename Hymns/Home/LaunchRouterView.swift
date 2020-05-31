import SwiftUI

struct LaunchRouterView: View {
    @ObservedObject var viewRouter: LaunchViewRouter

    init() {
        self.viewRouter = LaunchViewRouter()
    }

    var body: some View {
        VStack {
            if viewRouter.currentPage == "onboardingView" {
                SplashRouter()
            } else if viewRouter.currentPage == "homeView" {
                HomeContainerView()
            }
        }
    }
}

class LaunchViewRouter: ObservableObject {

    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = "homeView"
        }
    }

    @Published var currentPage: String
}
