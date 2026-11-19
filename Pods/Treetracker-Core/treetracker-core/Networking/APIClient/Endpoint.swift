import Foundation

enum Endpoint {
    case messages

    var rawValue: String {
        switch self {
        case .messages:
            return "messaging/message"
        }
    }
}
