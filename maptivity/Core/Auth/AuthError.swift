import Foundation

enum AuthError: Error {
    case noValidTokens
    case noRefreshToken
    case tokenProcessingFailed
    case loginFailed(String)
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .noValidTokens:
            return "No valid authentication tokens found"
        case .noRefreshToken:
            return "No refresh token found to renew access token"
        case .tokenProcessingFailed:
            return "Failed to process authentication tokens"
        case .loginFailed(let message):
            return "Login failed: \(message)."
        case .networkError(let error):
            return error.localizedDescription
        case .decodingError(let error):
            return error.localizedDescription
        case .invalidResponse:
            return "Received invalid response from server."
        case .unauthorized:
            return "Authentication failed, try logging in again."
        }
    }
}

