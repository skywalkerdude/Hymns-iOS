import Foundation

/**
 * A generic class that holds a value with its loading status.
 */
struct Resource<Value> {
    let status: Status
    let data: Value?
}

extension Resource {
    static func success(data: Value?) -> Resource<Value> {
        Resource(status: .success, data: data)
    }

    static func loading(data: Value?) -> Resource<Value> {
        Resource(status: .loading, data: data)
    }
}

/**
 * Status of a resource that is provided to the UI.
 *
 * These are usually created by the Repository classes where they return {@code LiveData<Resource<T>>} to pass back the
 * latest data to the UI with its fetch status.
 */
enum Status {
    case success
    case loading
}
