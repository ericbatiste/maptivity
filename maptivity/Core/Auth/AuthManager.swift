import SwiftUI
import Foundation

@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String? = nil
    
    private let authRequests = AuthRequests()
    private let keychain = Keychain()
    private let tokenBufferTime: TimeInterval = 300
    
    init() {
        checkAuthState()
    }
    
    private func isAccessTokenValid() -> Bool {
        guard let accessToken = keychain.getAccessToken(),
              let exp = JWTParser.getExpirationDate(from: accessToken) else {
            return false
        }
        
        return exp.timeIntervalSinceNow > tokenBufferTime
    }
    
    func checkAuthState() {
        if isAccessTokenValid() {
            isAuthenticated = true
        } else if keychain.getRefreshToken() != nil {
            Task {
                try await refreshAccessToken()
            }
        } else {
            isAuthenticated = false
        }
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let response = try await authRequests.login(email: email, password: password)
            keychain.setTokens(access: response.accessToken, refresh: response.refreshToken)
            isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() async {
        guard let accessToken = keychain.getAccessToken() else {
            keychain.clearTokens()
            isAuthenticated = false
            return
        }
        
        isLoading = true
        error = nil

        do {
            try await authRequests.logout(accessToken: accessToken)
        } catch {
            self.error = error.localizedDescription
        }
        
        keychain.clearTokens()
        isAuthenticated = false
        isLoading = false
    }
    
    func getValidAccessToken() async throws -> String? {
        if let accessToken = keychain.getAccessToken() {
            if let exp = JWTParser.getExpirationDate(from: accessToken),
               exp.timeIntervalSinceNow > tokenBufferTime {
                return accessToken
            }
        }
        
        guard keychain.getRefreshToken() != nil else {
            throw AuthError.noValidTokens
        }
        
        try await refreshAccessToken()
        return keychain.getAccessToken()
    }
    
    private func refreshAccessToken() async throws {
        guard let refreshToken = keychain.getRefreshToken() else {
            error = "No refresh token available"
            isAuthenticated = false
            throw AuthError.noRefreshToken
        }
        
        isLoading = true
        
        do {
            let response = try await authRequests.refreshToken(refreshToken: refreshToken)
            keychain.setTokens(access: response.accessToken, refresh: response.refreshToken)
            isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
            isAuthenticated = false
            throw error
        }
        isLoading = false
    }
}
