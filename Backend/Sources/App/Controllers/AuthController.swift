import Vapor
import Fluent
import JWT

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("register", use: register)
        auth.post("login", use: login)
    }
    
    private func register(req: Request) async throws -> User.Public {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        
        guard try await User.query(on: req.db)
            .filter(\.$email == create.email)
            .first() == nil else {
            throw Abort(.conflict, reason: "Email already exists")
        }
        
        let passwordHash = try req.password.hash(create.password)
        let user = User(
            name: create.name,
            email: create.email,
            passwordHash: passwordHash
        )
        
        try await user.save(on: req.db)
        return user.convertToPublic()
    }
    
    private func login(req: Request) async throws -> [String: String] {
        let credentials = try req.content.decode(LoginCredentials.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == credentials.email)
            .first() else {
            throw Abort(.unauthorized)
        }
        
        guard try req.password.verify(credentials.password, created: user.passwordHash) else {
            throw Abort(.unauthorized)
        }
        
        let payload = TokenPayload(
            subject: .init(value: user.id?.uuidString ?? ""),
            expiration: .init(value: Date().addingTimeInterval(86400))
        )
        
        return ["token": try req.jwt.sign(payload)]
    }
}

struct LoginCredentials: Content {
    let email: String
    let password: String
} 