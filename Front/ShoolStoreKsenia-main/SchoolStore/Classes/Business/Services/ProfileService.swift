
import Foundation
protocol ProfileService: AnyObject {
    func getProfile(completion: ((Result<Profile, Error>) -> Void)?)
    func userChange(profile: Profile, completion: ((Result<Void, Error>) -> Void)?)
}

final class ProfileServiceImpl: ProfileService {
    func getProfile(completion: ((Result<Profile, Error>) -> Void)?) {
        guard let userId = Int(dataService.appState.accessToken ?? "") else {
            return
        }
        
        networkProvider.make(
            UserRequest.getProfile(id: userId),
            completion: {(result: Result<Profile, Error>) in
                switch result {
                case let .success(data):
                    completion?(Result.success(data))
                case let .failure(error):
                    completion?(Result.failure(error))
                }
            },
            keyDecodingStrategy: .useDefaultKeys
        )
    }
    
    func userChange(profile: Profile, completion: ((Result<Void, Error>) -> Void)?) {
        networkProvider.make(
            UserRequest.userChange(profile: profile),
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
    
    typealias UserChange = DataResponse<Profile>
    
    init(networkProvider: NetworkProvider, dataService: DataService) {
        self.networkProvider = networkProvider
        self.dataService = dataService
    }
    
    private let networkProvider: NetworkProvider
    private let dataService: DataService
}
