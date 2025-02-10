import Foundation

class AuthService {
    static let shared = AuthService()
    private let api = APIClient.shared
    
    private init() {}
    
    func login(_ credentials: User.Login) async throws -> String {
        let endpoint = Endpoint(path: "/auth/login", method: .post, body: credentials)
        let response: TokenResponse = try await api.request(endpoint)
        return response.token
    }
    
    func register(_ user: User.Create) async throws -> User.Public {
        let endpoint = Endpoint(path: "/auth/register", method: .post, body: user)
        return try await api.request(endpoint)
    }
    
    func logout() {
        api.clearToken()
    }
}
