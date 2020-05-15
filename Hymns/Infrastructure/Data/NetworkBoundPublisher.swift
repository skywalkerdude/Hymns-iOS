import Combine
import Foundation

/**
 * A generic publisher that publishes data  backed by both a database and the network.
 */
protocol NetworkBoundSubscription: class, Subscription {

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

    associatedtype SubscriberType: Subscriber where SubscriberType.Input == UIResultType, SubscriberType.Failure == ErrorType

    var subscriber: SubscriberType? {get set}

    func saveToDatabase(convertedNetworkResult: DatabaseResultType)

    func shouldFetch(uiResult: UIResultType?) -> Bool

    /**
     * Converts the network result to the equivalent database result type.
     */
    func convertType(networkResult: NetworkResultType) throws -> DatabaseResultType

    /**
     * Converts the database result to the type consumed by the UI.
     */
    func convertType(databaseResult: DatabaseResultType) throws -> UIResultType

    func loadFromDatabase() -> AnyPublisher<DatabaseResultType, ErrorType>

    func createNetworkCall() -> AnyPublisher<NetworkResultType, ErrorType>
}

extension NetworkBoundSubscription {
    func cancel() {
        subscriber = nil
    }
}

extension NetworkBoundSubscription {

    /**
     * Perform some prework for the `NetworkBoundResource` before it performs any requests.
     */
    func prework() {
        // subclasses can implement
    }

    func execute(disposables: inout Set<AnyCancellable>) {
        guard let subscriber = subscriber else { return }
        prework()

        var disposables2 = Set<AnyCancellable>()
        loadFromDatabase()
            .sink(
                receiveCompletion: { state in
                    switch state {
                    case .failure:
                        if self.shouldFetch(uiResult: nil) {
                            self.fetchFromNetwork(disposables: &disposables2)
                        } else {
                            subscriber.receive(completion: state)
                        }
                    case .finished:
                        break
                    }
            }, receiveValue: { dbResult in
                do {
                    let uiResult = try self.convertType(databaseResult: dbResult)
                    if self.shouldFetch(uiResult: uiResult) {
                        _ = subscriber.receive(uiResult)
                        self.fetchFromNetwork(disposables: &disposables2)
                    } else {
                        _ = subscriber.receive(uiResult)
                        subscriber.receive(completion: .finished)
                    }
                } catch {
                    if self.shouldFetch(uiResult: nil) {
                        self.fetchFromNetwork(disposables: &disposables2)
                    } else {
                        subscriber.receive(completion: .failure(ErrorType.parsing(description: "error occured while converting the database response")))
                    }
                }
            }).store(in: &disposables)
    }

    private func fetchFromNetwork(disposables: inout Set<AnyCancellable>) {
        guard let subscriber = subscriber else { return }
        createNetworkCall()
            .tryMap({ networkResult -> UIResultType in
                let convertedNetworkResponse = try self.convertType(networkResult: networkResult)
                self.saveToDatabase(convertedNetworkResult: convertedNetworkResponse)
                return try self.convertType(databaseResult: convertedNetworkResponse)
            }).mapError({ error -> ErrorType in
                switch error {
                case let error as TypeConversionError:
                    return .parsing(description: error.triggeringError.localizedDescription)
                default:
                    return .data(description: error.localizedDescription)
                }
            })
            .sink(receiveCompletion: { state in
                subscriber.receive(completion: state)
            }, receiveValue: { uiResult in
                _ = subscriber.receive(uiResult)
            }).store(in: &disposables)
    }
}

protocol NetworkBoundPublisher: Publisher where Output == UIResultType, Failure == ErrorType {

    associatedtype UIResultType

    func createSubscription<S>(_ subscriber: S) -> Subscription where S: Subscriber, S.Failure == ErrorType, S.Input == UIResultType
}

extension NetworkBoundPublisher {

    func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = createSubscription(subscriber)
        subscriber.receive(subscription: subscription)
    }
}

struct TypeConversionError: Error {
    let triggeringError: Error
}
