import Combine
import Foundation

/**
 * A generic class that can provide a resource backed by both a database and the network.
 */
protocol NetworkBoundResource {

    /**
     * The type of the database response.
     */
    associatedtype DatabaseResultType

    /**
     * The type of the network response.
     */
    associatedtype NetworkResultType

    /**
     * The type of the  response returned to the UI.
     */
    associatedtype UIResultType

    // dummy comment to delete later
    func saveToDatabase(convertedNetworkResult: DatabaseResultType)

    func shouldFetch(uiResult: UIResultType?) -> Bool

    /**
     * Converts the network result to the equivalent database result type.
     */
    func convertType(networkResult: NetworkResultType) throws -> DatabaseResultType?

    /**
     * Converts the database result to the type consumed by the UI.
     */
    func convertType(databaseResult: DatabaseResultType?) throws -> UIResultType?

    func loadFromDatabase() -> AnyPublisher<DatabaseResultType?, ErrorType>

    func createNetworkCall() -> AnyPublisher<NetworkResultType, ErrorType>
}

struct TypeConversionError: Error {
    let triggeringError: Error
}

extension NetworkBoundResource {

    /**
     * Perform some prework for the `NetworkBoundResource` before it performs any requests.
     */
    func prework() {
        // subclasses can implement
    }

    func execute(disposables: inout Set<AnyCancellable>) -> AnyPublisher<Resource<UIResultType>, ErrorType> {
        prework()
        let publisher = CurrentValueSubject<Resource<UIResultType>, ErrorType>(Resource.loading(data: nil))
        var callbackDisposables = Set<AnyCancellable>()
        loadFromDatabase()
            .sink(
                receiveCompletion: { state in
                    switch state {
                    case .failure:
                        if self.shouldFetch(uiResult: nil) {
                            publisher.send(Resource.loading(data: nil))
                            self.fetchFromNetwork(disposables: &callbackDisposables, publisher: publisher)
                        } else {
                            publisher.send(completion: state)
                        }
                    case .finished:
                        break
                    }
            },
                receiveValue: { dbResult in
                    do {
                        let uiResult = try self.convertType(databaseResult: dbResult)
                        if self.shouldFetch(uiResult: uiResult) {
                            publisher.send(Resource.loading(data: uiResult))
                            self.fetchFromNetwork(disposables: &callbackDisposables, publisher: publisher)
                        } else {
                            publisher.send(Resource.success(data: uiResult))
                        }
                    } catch {
                        if self.shouldFetch(uiResult: nil) {
                            publisher.send(Resource.loading(data: nil))
                            self.fetchFromNetwork(disposables: &callbackDisposables, publisher: publisher)
                        } else {
                            publisher.send(completion: .failure(ErrorType.parsing(description: "error occured while converting the database response")))
                        }
                    }
            })
            .store(in: &disposables)
        return publisher.eraseToAnyPublisher()
    }

    private func fetchFromNetwork(
        disposables: inout Set<AnyCancellable>,
        publisher: CurrentValueSubject<Resource<UIResultType>, ErrorType>) {

        createNetworkCall()
            .sink(
                receiveCompletion: { state in
                    switch state {
                    case .failure:
                        publisher.send(completion: state)
                    case .finished:
                        break
                    }
            },
                receiveValue: { networkResult in
                    do {
                        guard let convertedNetworkResponse = try self.convertType(networkResult: networkResult) else {
                            publisher.send(Resource.success(data: nil))
                            return
                        }
                        self.saveToDatabase(convertedNetworkResult: convertedNetworkResponse)
                        let uiResult = try self.convertType(databaseResult: convertedNetworkResponse)
                        publisher.send(Resource.success(data: uiResult))
                    } catch {
                        publisher.send(completion: .failure(ErrorType.parsing(description: "error occured while converting the network response")))
                    }
            })
            .store(in: &disposables)
    }
}
