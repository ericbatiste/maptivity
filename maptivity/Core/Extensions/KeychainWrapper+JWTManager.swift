import Foundation

extension KeychainWrapper {
    private enum TokenKeys {
        static let access = "access_token"
        static let refresh = "refresh_token"
    }
    
    func setTokens(access: String, refresh: String) {
        set(access, forKey: TokenKeys.access)
        set(refresh, forKey: TokenKeys.refresh)
    }
    
    func getAccessToken() -> String? {
        get(forKey: TokenKeys.access)
    }
    
    func getRefreshToken() -> String? {
        get(forKey: TokenKeys.refresh)
    }
    
    func clearTokens() {
        delete(forKey: TokenKeys.access)
        delete(forKey: TokenKeys.refresh)
    }
}
