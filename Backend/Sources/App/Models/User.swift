import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Children(for: \.$user)
    var bookings: [Booking]
    
    init() { }
    
    init(id: UUID? = nil, name: String, email: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
    }
    // Add Public DTO
    struct Public: Content {
        let id: UUID?
        let name: String
        let email: String
    }
    
    // Add Create DTO
    struct Create: Content {
        let name: String
        let email: String
        let password: String
    }
    
    func convertToPublic() -> Public {
        return Public(id: id, name: name, email: email)
    }
}

// Add Authenticatable conformance
extension User: Authenticatable { }

// Add validation support
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User: @unchecked Sendable {}