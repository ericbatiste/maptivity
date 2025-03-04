import Foundation

class TokenManager: ObservableObject {
    private let keychain = Keychain()
    private let tokenBufferTime: TimeInterval = 300
    private let rootPath = "http://localhost:3000/api/v1/"
    
    init() {}
    
    func getValidAccessToken() async throws -> String {
        if let accessToken = keychain.getAccessToken() {
            if let exp = JWTParser.getExpirationDate(from: accessToken),
               exp.timeIntervalSinceNow > tokenBufferTime {
                return accessToken
            }
        }
        
        guard let refreshToken = keychain.getRefreshToken() else {
            throw AuthError.noValidTokens
        }
        
        return try await refreshAccessToken(refreshToken: refreshToken)
    }
    
    private func refreshAccessToken(refreshToken: String) async throws -> String {
        guard let url = URL(string: rootPath + "auth/refresh") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(["refresh_token": refreshToken])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(TokenResponse.self, from: data)
            
            keychain.setTokens(access: response.accessToken, refresh: response.refreshToken)
            
            return response.accessToken
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    
}

