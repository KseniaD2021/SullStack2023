 

import Foundation

enum UserRequest: Request {
    case login(user: String, password: String)
    case getProfile(id: Int)
    case userChange(profile: Profile)

    // MARK: Internal

    var path: String {
        switch self {
        case let .login(user: user, password: password):
            return "login/\(user)&\(password)"
        case let .getProfile(id: id):
            return "person/\(id)"
        case let .userChange(person):
            return "person/\(person.id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .login:
            return .get
        case .getProfile:
            return .get
        case .userChange:
            return .put
        }
    }

    var body: Data? {
        switch self {
        case let .userChange(profile):
            return RequestBuilderImpl.encode(profile)
        default:
            return nil
        }
    }

    var mock: Data? {
        nil
    }
}
