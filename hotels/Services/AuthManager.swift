import SwiftUI

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @AppStorage("authToken") private var storedToken: String?
    @AppStorage("userId") private var storedUserId: String?
    
    var token: String? {
        return storedToken
    }
    
    var userId: UUID? {
        guard let idString = storedUserId else { return nil }
        return UUID(uuidString: idString)
    }
    
    private init() {}
    
    func login(email: String, password: String) async throws {
        let credentials = LoginRequest(email: email, password: password)
        let endpoint = Endpoint(path: "/auth/login", method: .post, body: credentials)
        let response: TokenResponse = try await APIClient.shared.request(endpoint)
        
        if let userId = extractUserIdFromToken(response.token) {
            await MainActor.run {
                self.storedToken = response.token
                self.storedUserId = userId
                self.isAuthenticated = true
            }
        } else {
            throw AuthError.invalidToken
        }
    }
    
    func register(name: String, email: String, password: String) async throws {
        let request = RegisterRequest(name: name, email: email, password: password)
        let endpoint = Endpoint(path: "/auth/register", method: .post, body: request)
        let response: TokenResponse = try await APIClient.shared.request(endpoint)
        
        if let userId = extractUserIdFromToken(response.token) {
            await MainActor.run {
                self.storedToken = response.token
                self.storedUserId = userId
                self.isAuthenticated = true
            }
        } else {
            throw AuthError.invalidToken
        }
    }
    
    private func extractUserIdFromToken(_ token: String) -> String? {
        let parts = token.components(separatedBy: ".")
        guard parts.count == 3,
              let payloadData = base64Decode(parts[1]),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let subject = json["subject"] as? String else {
            return nil
        }
        return subject
    }
    
    private func base64Decode(_ base64: String) -> Data? {
        var base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        
        return Data(base64Encoded: base64)
    }
    
    func signOut() {
        storedToken = nil
        storedUserId = nil
        isAuthenticated = false
    }
}

struct TokenResponse: Codable {
    let token: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let password: String
}

enum AuthError: Error {
    case invalidToken
    case unauthorized
    case invalidCredentials
    case networkError
    case unknown
}