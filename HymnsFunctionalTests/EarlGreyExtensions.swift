import EarlGrey

public extension EarlGrey {

    class func element(_ accessibilityLabel: String, file: StaticString = #file, line: UInt = #line) -> GREYInteraction {
        return selectElement(with: grey_accessibilityLabel(accessibilityLabel), file: file, line: line).atIndex(0).assert(grey_sufficientlyVisible())
    }

    class func element(withID accessibilityID: String, file: StaticString = #file, line: UInt = #line) -> GREYInteraction {
        return selectElement(with: grey_accessibilityID(accessibilityID), file: file, line: line).atIndex(0).assert(grey_sufficientlyVisible())
    }

    class func keyWindow(file: StaticString = #file, line: UInt = #line) -> GREYInteraction {
        return selectElement(with: grey_keyWindow(), file: file, line: line).assert(grey_sufficientlyVisible())
    }

    class func doesElementExist(_ accessibilityLabel: String, file: StaticString = #file, line: UInt = #line) -> Bool {
        var error: NSError?
        selectElement(with: grey_accessibilityLabel(accessibilityLabel), file: file, line: line).atIndex(0).assert(grey_notNil(), error: &error)
        return error == nil
    }

    class func dismissKeyboard(withError errorOrNil: UnsafeMutablePointer<NSError?>! = nil, file: StaticString = #file, line: UInt = #line) {
        self.synchronized(false) {
            EarlGreyImpl.invoked(fromFile: file.description, lineNumber: line).dismissKeyboardWithError(errorOrNil)
        }
    }

    // MARK: Synchronization API
    class func synchronized(_ enabled: Bool = true, _ block: () -> Void) {
        let configuration = GREYConfiguration.sharedInstance()
        let originalValue = configuration.boolValue(forConfigKey: kGREYConfigKeySynchronizationEnabled)

        configuration.setValue(enabled, forConfigKey: kGREYConfigKeySynchronizationEnabled)
        block()
        configuration.setValue(originalValue, forConfigKey: kGREYConfigKeySynchronizationEnabled)
    }

    class func wait(seconds: CFTimeInterval = 2) {
        GREYCondition(name: "manual wait") {
            return false
        }.wait(withTimeout: seconds)
    }
}
