
import Foundation

// MARK: - OrderService

protocol OrderService: AnyObject {
    func sendOrder(order: CreatedOrder, completion: ((Result<Void, Error>) -> Void)?)
}

// MARK: - OrderServiceImpl

final class OrderServiceImpl: OrderService {
    func sendOrder(order: CreatedOrder, completion: ((Result<Void, Error>) -> Void)?) {
        networkProvider.make(
            OrdersRequest.createOrder(order: order),
            completion: { (result: Result<Bool, Error>) in
                switch result {
                case .success:
                    completion?(Result.success(()))
                case let .failure(error):
                    completion?(Result.failure(error))
                }
            },
            keyDecodingStrategy: .useDefaultKeys
        )
    }
    
    // MARK: Lifecycle
    
    init(networkProvider: NetworkProvider, dataService: DataService) {
        self.networkProvider = networkProvider
        self.dataService = dataService
    }
    
    // MARK: Internal
    
    
    // MARK: Private
    
    private let networkProvider: NetworkProvider

    private let dataService: DataService
}


