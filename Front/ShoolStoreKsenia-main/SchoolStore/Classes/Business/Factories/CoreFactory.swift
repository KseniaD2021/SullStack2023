
import Foundation

enum CoreFactory {
    static let requestBuilder: RequestBuilder = RequestBuilderImpl(dataService: Self.dataService)

    static let networkProvider: NetworkProvider = NetworkProviderImpl(requestBuilder: requestBuilder)

    static let snacker: Snacker = SnackerImpl()

    static let dataService: DataService = DataServiceImpl()

    static func buildAuthService() -> AuthService {
        AuthServiceImpl(networkProvider: Self.networkProvider, dataService: Self.dataService)
    }

    static func buildCatalogService() -> CatalogService {
        CatalogServiceImpl(networkProvider: Self.networkProvider, dataService: Self.dataService)
    }
    
    static func buildHistoryService() -> HistoryService {
        HistoryServiceImpl(networkProvider: Self.networkProvider, dataService: Self.dataService)
    }
    
    static func buildOrderService() -> OrderService {
        OrderServiceImpl(networkProvider: Self.networkProvider, dataService: Self.dataService)
    }
    static func buildProfileService() -> ProfileService {
        ProfileServiceImpl(networkProvider: Self.networkProvider, dataService: Self.dataService)
    }
    static func buildEditServise() -> AuthService {
        AuthServiceImpl(networkProvider: Self.networkProvider, dataService: Self.dataService)
    }
}
