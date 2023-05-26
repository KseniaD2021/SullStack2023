
import Foundation
import KeychainAccess

// MARK: - DataService

protocol DataService: AnyObject {
    var appState: AppState { get set }
}

// MARK: - DataServiceImpl

final class DataServiceImpl: DataService {
    // MARK: Lifecycle

    init() {
        keychain = Keychain()
        userDefaults = UserDefaults.standard

        appState = AppState(
            accessToken: keychain[Keys.accessToken.rawValue]
        )
    }

    // MARK: Internal

    var appState: AppState {
        didSet {
            keychain[Keys.accessToken.rawValue] = appState.accessToken
        }
    }

    // MARK: Private

    private enum Keys: String {
        case accessToken
    }

    private let keychain: Keychain

    private let userDefaults: UserDefaults
}
