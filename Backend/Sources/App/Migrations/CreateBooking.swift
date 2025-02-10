import Fluent

struct CreateBooking: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Booking.schema)
            .id()
            .field("user_id", .uuid, .required, .references(User.schema, "id"))
            .field("room_id", .uuid, .required, .references(Room.schema, "id"))
            .field("check_in", .datetime, .required)
            .field("check_out", .datetime, .required)
            .field("total_price", .double, .required)
            .field("status", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Booking.schema).delete()
    }
} 