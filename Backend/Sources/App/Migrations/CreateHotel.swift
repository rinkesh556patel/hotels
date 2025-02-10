import Fluent

struct CreateHotel: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Hotel.schema)
            .id()
            .field("name", .string, .required)
            .field("location", .string, .required)
            .field("description", .string, .required)
            .field("price_per_night", .double, .required)
            .field("rating", .double, .required)
            .field("amenities", .array(of: .string), .required)
            .field("image_urls", .array(of: .string), .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Hotel.schema).delete()
    }
} 