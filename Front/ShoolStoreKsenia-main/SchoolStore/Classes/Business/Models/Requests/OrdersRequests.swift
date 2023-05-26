 
import Foundation

enum OrdersRequest: Request {
    case listOfOrders(userId: Int)
    case createOrder(order: CreatedOrder)
    case cancel(Int)

    // MARK: Internal

    var path: String {
        switch self {
        case let .listOfOrders(userId):
            return "orders/\(userId)"
        case .createOrder:
            return "createOrder"
        case let .cancel(id):
            return "order/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .listOfOrders:
            return .get
        case .createOrder:
            return .post
        case .cancel:
            return .delete
        }
    }

    var body: Data? {
        switch self {
        case let .createOrder(order):
            return RequestBuilderImpl.encode(order)
        default:
            return nil
        }
    }

    var mock: Data? {
        nil
    }
}
