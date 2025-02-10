import Fluent
import FluentPostgresDriver
import Vapor
import JWT

public func configure(_ app: Application) throws {
    // Set port explicitly
    app.http.server.configuration.port = 8080
    app.http.server.configuration.hostname = "0.0.0.0"
    
    // CORS middleware
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
    )
    app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
    
    // Database configuration
    if app.environment == .production {
        let configuration = try PostgresConfiguration(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
            username: Environment.get("DATABASE_USERNAME") ?? "postgres",
            password: Environment.get("DATABASE_PASSWORD") ?? "postgres",
            database: Environment.get("DATABASE_NAME") ?? "hotel_db",
            tlsConfiguration: .makeClientConfiguration()
        )
        app.databases.use(.postgres(configuration: configuration), as: .psql)
    } else {
        // Development configuration without TLS
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
            username: Environment.get("DATABASE_USERNAME") ?? "postgres",
            password: Environment.get("DATABASE_PASSWORD") ?? "postgres",
            database: Environment.get("DATABASE_NAME") ?? "hotel_db"
        ), as: .psql)
    }
    
    // JWT configuration
    if let jwtSecret = Environment.get("JWT_SECRET") {
        app.jwt.signers.use(.hs256(key: jwtSecret))
    }
    
    // Register migrations
    app.migrations.add(CreateUser())
    app.migrations.add(CreateHotel())
    app.migrations.add(CreateRoom())
    app.migrations.add(CreateBooking())
    app.migrations.add(SeedData())
    
    // Register routes
    try routes(app)
} 