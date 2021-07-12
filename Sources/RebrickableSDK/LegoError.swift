import Foundation
import Combine

public enum LegoError: Error {
    case decode(type: DecodingError)
    case formatRequestWrong
    case invalidApiKey
    case notItemAcess
    case itemNotFound
    case throttledRequest
    case generic(Error)
    
    public var message: String {
        switch self {
            case .decode(let type): return "decoding failed: \(type)"
            case .formatRequestWrong : return "Something was wrong with the format of your request"
            case .invalidApiKey : return "Unauthorized - your API key is invalid"
            case .notItemAcess : return "Forbidden - you do not have access to operate on the requested item(s)"
            case .itemNotFound : return "Item not found"
            case .throttledRequest : return "Request was throttled. Expected available in 2 seconds."
            case .generic(let error): return error.localizedDescription
        }
    }
}

extension Publisher {
    func mapToLegoError() -> Publishers.MapError<Self, LegoError> {
        mapError { error -> LegoError in
            switch error {
            case is DecodingError: return LegoError.decode(type: error as! DecodingError)
                case is URLError: return error.toLegoError
                default: return .generic(error)
            }
        }
    }
}

fileprivate extension Error {
    var toLegoError: LegoError {
        guard let errorCode = (self as? URLError)?.errorCode else { return .generic(self) }
        switch errorCode {
            case 400: return .formatRequestWrong
            case 401: return .invalidApiKey
            case 403: return .notItemAcess
            case 404: return .itemNotFound
            case 429: return .throttledRequest
            default: return .generic(self)
        }
    }
}
