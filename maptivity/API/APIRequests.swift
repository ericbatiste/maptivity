import SwiftUI

class APIRequests {
    static let shared = APIRequests()
    let rootPath = "http://localhost:3000/api/v1/users/"
    let userID: Int = 1
    
    func fetchActivities() async throws -> [Activity] {
        guard let url = URL(string: "\(rootPath)\(userID)/activities") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let activities = try decoder.decode([Activity].self, from: data)
            
            return activities
            
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func createActivity(_ post: NewActivity) async throws -> Activity {
        guard let url = URL(string: "\(rootPath)\(userID)/activities") else {
            throw APIError.invalidURL
        }
    
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(post)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let createdActivity = try decoder.decode(Activity.self, from: data)
            
            return createdActivity
            
        } catch let error as EncodingError {
            throw APIError.encodingError(error)
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
}

