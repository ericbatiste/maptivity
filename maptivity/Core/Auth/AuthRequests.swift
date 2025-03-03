import Foundation
import Combine

class AuthRequests {
    private let rootPath = "http://localhost:3000/api/v1/"
    
    func login(email: String, password: String) async throws -> AuthResponse {
        guard let url = URL(string: rootPath + "/auth/login") else {
            throw AuthError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let credentials = ["email": email, "password": password]
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials)
        
        return try await performRequest(request)
    }
    
    func logout(accessToken: String) async throws {
        guard let url = URL(string: rootPath + "/auth/logout") else {
            throw AuthError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.invalidResponse
        }
    }
    
    func refreshToken(refreshToken: String) async throws -> AuthResponse {
        guard let url = URL(string: rootPath + "/auth/refresh") else {
            throw AuthError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["refreshToken": refreshToken]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        return try await performRequest(request)
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            if httpResponse.statusCode == 401 {
                throw AuthError.unauthorized
            } else if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
                throw AuthError.invalidResponse
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            } catch {
                throw AuthError.decodingError(error)
            }
        } catch let urlError as URLError {
            throw AuthError.networkError(urlError)
        } catch {
            if let authError = error as? AuthError {
                throw authError
            }
            throw AuthError.networkError(error)
        }
    }
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
