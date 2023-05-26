 
import Foundation

// MARK: - CatalogService

protocol CatalogService: AnyObject {
    func getCatalogItems(with offset: Int, limit: Int, completion: ((Result<[Product], Error>) -> Void)?)
    func getProduct(with id: Int, completion: ((Result<Product, Error>) -> Void)?)
}

// MARK: - CatalogServiceImpl

final class CatalogServiceImpl: CatalogService {

    // MARK: Lifecycle

    init(networkProvider: NetworkProvider, dataService: DataService) {
        self.networkProvider = networkProvider
        self.dataService = dataService
    }

    // MARK: Internal

    func getCatalogItems(with offset: Int, limit: Int, completion: ((Result<[Product], Error>) -> Void)?) {
        networkProvider.make(
            CatalogRequest.listOfProducts(offset: offset, limit: limit)
        ) { (result: Result<[Product], Error>) in
            switch result {
            case .success:
                completion?(result)
            case let .failure(error):
                completion?(Result.failure(error))
            }
        }
    }

    func getProduct(with id: Int, completion: ((Result<Product, Error>) -> Void)?) {
        networkProvider.make(
            CatalogRequest.detailInfo(id: id)
        ) { (result: Result<Product, Error>) in
            switch result {
            case .success:
                completion?(result)
            case let .failure(error):
                completion?(Result.failure(error))
            }
        }
    }

    // MARK: Private

    private let networkProvider: NetworkProvider
    private let dataService: DataService
}
