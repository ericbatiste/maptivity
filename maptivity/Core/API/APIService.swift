import Foundation

class APIService: ObservableObject {
    private let rootPath: URL
    private let tokenManager: TokenManager
    
    init(tokenManager: TokenManager) {
        guard let urlString = Bundle.main.infoDictionary?["DatabaseURL"] as? String,
              let path = URL(string: urlString) else {
            fatalError("Database URL not found or is invalid")
        }
        self.rootPath = path
        self.tokenManager = tokenManager
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        var request = URLRequest(url: rootPath.appendingPathComponent(endpoint))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            do {
                let accessToken = try await tokenManager.getValidAccessToken()
                request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } catch {
                throw APIError.unauthorized
            }
        }
        
        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.encodingError(error)
            }
            
        }
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let error {
            throw APIError.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decodingError(error)
            }
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}

