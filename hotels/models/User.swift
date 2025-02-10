import Foundation

struct User: Codable, Identifiable {
    let id: UUID?
    let name: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
    
    // Public DTO for safe data transfer
    struct Public: Codable {
        let id: UUID?
        let name: String
        let email: String
    }
    
    // Create DTO for registration
    struct Create: Codable {
        let name: String
        let email: String
        let password: String
    }
    
    // Login credentials
    struct Login: Codable {
        let email: String
        let password: String
    }
    
    // Convert to public version
    func toPublic() -> Public {
        Public(id: id, name: name, email: email)
    }
}

extension User {
    static func mock() -> User {
        User(id: UUID(), name: "John Doe", email: "john@example.com")
    }
}

// Response types
struct UserResponse: Codable {
    let user: User
    let token: String?
}

// Request types
struct RegisterUser: Codable {
    let name: String
    let email: String
    let password: String
}

struct LoginCredentials: Codable {
    let email: String
    let password: String
} 