enum APIError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    case encodingError(Error)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Data decoding error: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Data encoding error: \(error.localizedDescription)"
        }
    }
}

