 
import Foundation

struct Profile: Decodable, Hashable, Equatable, Encodable {
    let id: Int
    let authId: Int
    let name: String
    let surname: String
    let occupation: String
    let avatarUrl: String?
}
