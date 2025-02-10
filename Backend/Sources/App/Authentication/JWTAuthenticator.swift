import Vapor
import JWT

struct JWTAuthenticator: AsyncBearerAuthenticator {
    typealias User = App.User
    
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        let payload = try request.jwt.verify(bearer.token, as: TokenPayload.self)
        guard let userID = UUID(uuidString: payload.subject.value) else {
            throw Abort(.unauthorized)
        }
        
        guard let user = try await User.find(userID, on: request.db) else {
            throw Abort(.unauthorized)
        }
        
        request.auth.login(user)
    }
}