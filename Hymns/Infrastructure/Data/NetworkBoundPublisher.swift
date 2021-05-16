import Combine
import Foundation

/**
 * A generic publisher that publishes data  backed by both a database and the network.
 */
protocol NetworkBoundSubscription: AnyObject, Subscription {

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

    var disposables: Set<AnyCancellable> {get set}

    func saveToDatabase(databaseResult: DatabaseResultType?, convertedNetworkResult: DatabaseResultType)

    func shouldFetch(convertedDatabaseResult: UIResultType?) -> Bool

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

    func request(_ demand: Subscribers.Demand) {
        // subclasses can override
        execute()
    }

    func execute() {
        guard let subscriber = subscriber else { return }
        prework()

        loadFromDatabase()
            .tryMap({ dbResult -> (databaseResult: DatabaseResultType, converetedDatabaseResult: UIResultType) in
                try (dbResult, self.convertType(databaseResult: dbResult))
            }).mapError({ error -> ErrorType in
                switch error {
                case let error as TypeConversionError:
                    return .parsing(description: error.triggeringError.localizedDescription)
                default:
                    return .data(description: error.localizedDescription)
                }
            }).sink(
                receiveCompletion: { state in
                    switch state {
                    case .failure:
                        if self.shouldFetch(convertedDatabaseResult: nil) {
                            self.fetchFromNetwork(databaseResult: nil, disposables: &self.disposables)
                        } else {
                            subscriber.receive(completion: state)
                        }
                    case .finished:
                        break
                    }
            }, receiveValue: { databaseResult, uiResult in
                if self.shouldFetch(convertedDatabaseResult: uiResult) {
                    _ = subscriber.receive(uiResult)
                    self.fetchFromNetwork(databaseResult: databaseResult, disposables: &self.disposables)
                } else {
                    _ = subscriber.receive(uiResult)
                    subscriber.receive(completion: .finished)
                }
            }).store(in: &disposables)
    }

    private func fetchFromNetwork(databaseResult: DatabaseResultType?, disposables: inout Set<AnyCancellable>) {
        guard let subscriber = subscriber else { return }
        createNetworkCall()
            .tryMap({ networkResult -> UIResultType in
                let convertedNetworkResponse = try self.convertType(networkResult: networkResult)
                self.saveToDatabase(databaseResult: databaseResult, convertedNetworkResult: convertedNetworkResponse)
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
