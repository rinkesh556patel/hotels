import Vapor

func routes(_ app: Application) throws {
    // Basic route for API info
    app.get { req async in
        "Hotel Management API v1.0"
    }
    
    // Documentation route
    app.get("docs") { req async -> String in
        APIDocumentation.description
    }
    
    // Register controllers
    try app.register(collection: AuthController())
    try app.register(collection: HotelController())
    try app.register(collection: BookingController())
} 