
import Foundation

class UserService {
    static let shared = UserService()
    private let api = APIClient.shared
    
    private init() {}
    
    func getCurrentUser() async throws -> User {
        print("Getting current user...")
        guard AuthManager.shared.isAuthenticated else {
            throw APIError.unauthorized
        }
        
        let endpoint = Endpoint(path: "/auth/me", method: .get)
        print("Calling /auth/me endpoint...")
        let user: User = try await api.request(endpoint)
        print("Received user response: \(user)")
        return user
    }
}