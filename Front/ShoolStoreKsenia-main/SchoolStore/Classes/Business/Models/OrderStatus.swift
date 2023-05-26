 
import Foundation

enum OrderStatus: String, Decodable, Equatable {
    case inWork = "in_work", done = "done", cancelled = "cancelled"
}
