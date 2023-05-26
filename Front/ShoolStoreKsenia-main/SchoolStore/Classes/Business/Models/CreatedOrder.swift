
import Foundation

struct CreatedOrder: Decodable, Hashable, Equatable, Encodable {
    let authId: Int
    let number: Int
    let productId: String
    let productPrevieew: String
    let productQuantity: Int
    let productSize: String
    let createdAt: String
    let etd: String
    let deliveryAddress: String
    let status: String
}
