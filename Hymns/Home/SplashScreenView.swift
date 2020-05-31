import SwiftUI
import Lottie

//Implemented using https://www.raywenderlich.com/4503153-how-to-create-a-splash-screen-with-swiftui
//And the help from https://www.youtube.com/watch?v=fVehE3Jf7K0
struct SplashScreenView: UIViewRepresentable {
    let animationView = AnimationView()
    var filename = "hymnalLaunchAnimation"

    func makeUIView(context: UIViewRepresentableContext<SplashScreenView>) -> UIView {
        let view = UIView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<SplashScreenView>) {
    }
}

struct SplashRouter: View {

    @State var showSplash = true

    var body: some View {

        ZStack {
            if !showSplash {
                HomeContainerView()
            } else {
                SplashScreenView()
                    .opacity(showSplash ? 1 : 0)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                            self.showSplash = false
                        }
                }
            }
        }
    }
}
