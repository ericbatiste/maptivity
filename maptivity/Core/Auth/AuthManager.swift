import SwiftUI
import Foundation

@MainActor
class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String? = nil
    
    private let tokenManager: TokenManager
    private let apiService: APIService
    private let keychain = Keychain()
    private let tokenBufferTime: TimeInterval = 300
    
    init(tokenManager: TokenManager, apiService: APIService) {
        self.tokenManager = tokenManager
        self.apiService = apiService
        checkAuthState()
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            let credentials = LoginRequest(email: email, password: password)
            
            let response: TokenResponse = try await apiService.request(
                endpoint: "auth/login",
                method: "POST",
                body: credentials,
                requiresAuth: false
            )
            
            keychain.setTokens(access: response.accessToken, refresh: response.refreshToken)
            isAuthenticated = true
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() async {
        guard let _ = keychain.getAccessToken() else {
            keychain.clearTokens()
            isAuthenticated = false
            return
        }
        
        isLoading = true
        error = nil

        do {
            let _: Bool = try await apiService.request(
                endpoint: "auth/logout",
                method: "DELETE",
                requiresAuth: true
            )
        } catch {
            self.error = error.localizedDescription
        }
        
        keychain.clearTokens()
        isAuthenticated = false
        isLoading = false
    }
    

    
    private func isAccessTokenValid() -> Bool {
        guard let accessToken = keychain.getAccessToken(),
              let exp = JWTParser.getExpirationDate(from: accessToken) else {
            return false
        }
        
        return exp.timeIntervalSinceNow > tokenBufferTime
    }
    
    private func checkAuthState() {
        if isAccessTokenValid() {
            isAuthenticated = true
        } else if keychain.getRefreshToken() != nil {
            Task {
                do {
                    _ = try await tokenManager.getValidAccessToken()
                    isAuthenticated = true
                } catch {
                    isAuthenticated = false
                    keychain.clearTokens()
                    self.error = error.localizedDescription
                }
            }
        } else {
            isAuthenticated = false
        }
    }
}
