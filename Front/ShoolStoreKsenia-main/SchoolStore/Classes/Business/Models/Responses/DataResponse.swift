
import Foundation

struct DataResponse<T: Decodable>: Decodable {
    let data: T
}
