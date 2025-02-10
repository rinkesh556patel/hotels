import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }
} 