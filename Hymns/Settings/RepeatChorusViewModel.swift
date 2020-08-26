import Foundation
import Resolver
import SwiftUI

class RepeatChorusViewModel: ObservableObject {

    @Published var shouldRepeatChorus: Binding<Bool>

    init(userDefaultManager: UserDefaultsManager = Resolver.resolve()) {
        self.shouldRepeatChorus = Binding<Bool>(
            get: {userDefaultManager.shouldRepeatChorus},
            set: {userDefaultManager.shouldRepeatChorus = $0})
    }
}
