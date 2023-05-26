
import Foundation

struct AuthResponse: Decodable {
    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        login = try container.decode(String.self, forKey: CodingKeys.login)
        password = try container.decode(String.self, forKey: CodingKeys.password)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case id, login, password
    }

    let id: Int
    let login: String
    let password: String
}
