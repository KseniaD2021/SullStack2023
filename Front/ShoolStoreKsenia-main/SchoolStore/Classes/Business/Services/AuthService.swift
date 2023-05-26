 
import Foundation

// MARK: - AuthService

protocol AuthService: AnyObject {
    func authenticate(user: String, password: String, completion: ((Result<AuthResponse, Error>) -> Void)?)
}

// MARK: - AuthServiceImpl

final class AuthServiceImpl: AuthService {
    // MARK: Lifecycle

    init(networkProvider: NetworkProvider, dataService: DataService) {
        self.networkProvider = networkProvider
        self.dataService = dataService
    }

    // MARK: Internal

    typealias Authenticated = DataResponse<AuthResponse>
    typealias getEditUser = DataResponse<User>

    func authenticate(user: String, password: String, completion: ((Result<AuthResponse, Error>) -> Void)?) {
        networkProvider.make(
            UserRequest.login(user: user, password: password),
            completion: { [weak self] (result: Result<AuthResponse, Error>) in
                switch result {
                case let .success(data):
                    self?.dataService.appState.userId = String(data.id)
                    self?.dataService.appState.accessToken = String(data.id)
                    completion?(Result.success(data))
                case let .failure(error):
                    completion?(Result.failure(error))
                }
            }
        )
    }
    
    // MARK: Private

    private let networkProvider: NetworkProvider
    private let dataService: DataService
}
