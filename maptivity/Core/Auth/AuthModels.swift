struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
