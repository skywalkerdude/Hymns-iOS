import SwiftUI

/**
 * Base protocol for a setting view model.
 */
protocol BaseSettingViewModel: Identifiable where ID == UUID {

    /**
     * Implementations should return the view assocaited with its partcilar setting here.
     */
    var view: AnyView { get }
}

extension BaseSettingViewModel {

    /**
     * Use type erasure as a way to return a generic protocol as a type, instead of forcing a concrete type (https://www.swiftbysundell.com/articles/type-erasure-using-closures-in-swift/).
     */
    func eraseToAnySettingViewModel() -> AnySettingViewModel {
        return AnySettingViewModel(id: self.id, view: self.view)
    }
}

/**
 * A type-erased `BaseSettingViewModel` where the `ID` is of type `UUID`
 */
struct AnySettingViewModel: BaseSettingViewModel {
    var id: UUID
    var view: AnyView
}
