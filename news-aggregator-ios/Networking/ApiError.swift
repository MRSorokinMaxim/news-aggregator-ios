struct ApiError: Error, Codable {
    enum Status: String, Codable {
        case ok
        case error
    }
    
    enum Code: String, Codable {
        case apiKeyDisabled
        case apiKeyExhausted
        case apiKeyInvalid
        case apiKeyMissing
        case parameterInvalid
        case parametersMissing
        case rateLimited
        case sourcesTooMany
        case sourceDoesNotExist
        case unknownError
        case timeoutError
    }
    
    let status: Status
    let code: Code
    let message: String
}

extension ApiError {
    static var defaultError: ApiError {
        ApiError(status: .error, code: .unknownError, message: "common_unknown_error".localized)
    }
    
    static var timeoutError: ApiError {
        ApiError(status: .error, code: .timeoutError, message: "common_timeout_error".localized)
    }
}
