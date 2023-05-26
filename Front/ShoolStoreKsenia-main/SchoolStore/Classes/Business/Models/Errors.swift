 

import Foundation

// MARK: - Errors

enum Errors: LocalizedError {
    case failedResponse(message: String, fields: [FieldError]?)
    case unknown

    // MARK: Internal

    var errorDescription: String? {
        switch self {
        case let .failedResponse(message, _):
            return message
        case .unknown:
            return L10n.Common.error
        }
    }
}
