import Fluent

struct CreateRoom: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Room.schema)
            .id()
            .field("hotel_id", .uuid, .required, .references(Hotel.schema, "id"))
            .field("type", .string, .required)
            .field("price", .double, .required)
            .field("capacity", .int, .required)
            .field("available", .bool, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Room.schema).delete()
    }
} 