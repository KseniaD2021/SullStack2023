
import Foundation

// MARK: - HistoryService

protocol HistoryService: AnyObject {
    func getOrdersList(completion: ((Result<[Order], Error>) -> Void)?)
    func deleteOrder(id: Int, completion: ((Result<Void, Error>) -> Void)?)
}

// MARK: - CatalogServiceImpl

final class HistoryServiceImpl: HistoryService {
    func getOrdersList(completion: ((Result<[Order], Error>) -> Void)?) {
        guard let userId = Int(dataService.appState.accessToken ?? "") else {
            return
        }
        
        networkProvider.make(
            OrdersRequest.listOfOrders(userId: userId),
            completion: { (result: Result<[Order], Error>) in
                switch result {
                case .success:
                    completion?(result)
                case let .failure(error):
                    completion?(Result.failure(error))
                }
            },
            keyDecodingStrategy: .useDefaultKeys
        )
    
    
    }
    
    func deleteOrder(id: Int, completion: ((Result<Void, Error>) -> Void)?) {
        networkProvider.make(
            OrdersRequest.cancel(id),
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
    
    // MARK: Private

    private let networkProvider: NetworkProvider
    private let dataService: DataService
}


