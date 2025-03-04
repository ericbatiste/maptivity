import SwiftUI

@main
struct maptivityApp: App {
    @StateObject private var tokenManager: TokenManager
    @StateObject private var apiService: APIService
    @StateObject private var authManager: AuthManager
    
    init() {
        let tokenManagerInstance = TokenManager()
        let apiServiceInstance = APIService(tokenManager: tokenManagerInstance)
        let authManagerInstance = AuthManager(
            tokenManager: tokenManagerInstance,
            apiService: apiServiceInstance
        )
        
        _tokenManager = StateObject(wrappedValue: tokenManagerInstance)
        _apiService = StateObject(wrappedValue: apiServiceInstance)
        _authManager = StateObject(wrappedValue: authManagerInstance)
    }
    
    var body: some Scene {
        WindowGroup {
            AuthRouter()
                .environmentObject(authManager)
                .environmentObject(apiService)
                .environmentObject(tokenManager)
        }
    }
}
