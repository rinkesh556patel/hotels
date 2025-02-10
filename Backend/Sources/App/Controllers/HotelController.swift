import Vapor
import Fluent

struct HotelController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let hotels = routes.grouped("hotels")
        hotels.get(use: index)
        hotels.get(":hotelID", use: show)
        hotels.get(":hotelID", "rooms", use: getRooms)
        hotels.get("search", use: search)
        
        // Protected routes
        let protected = hotels.grouped(JWTAuthenticator())
        protected.post(":hotelID", "favorite", use: toggleFavorite)
    }
    
    // List all hotels with optional filtering
    private func index(req: Request) async throws -> Page<Hotel> {
        let query = Hotel.query(on: req.db)
        
        // Apply filters
        if let minPrice = req.query[Double.self, at: "minPrice"] {
            query.filter(\.$pricePerNight >= minPrice)
        }
        if let maxPrice = req.query[Double.self, at: "maxPrice"] {
            query.filter(\.$pricePerNight <= maxPrice)
        }
        if let minRating = req.query[Double.self, at: "minRating"] {
            query.filter(\.$rating >= minRating)
        }
        if let location = req.query[String.self, at: "location"] {
            query.filter(\.$location ~~ location)
        }
        
        return try await query.paginate(for: req)
    }
    
    // Get specific hotel details
    private func show(req: Request) async throws -> Hotel {
        guard let hotel = try await Hotel.find(req.parameters.get("hotelID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return hotel
    }
    
    // Get rooms for a specific hotel
    private func getRooms(req: Request) async throws -> [Room] {
        guard let hotel = try await Hotel.find(req.parameters.get("hotelID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await hotel.$rooms.get(on: req.db)
    }
    
    // Search hotels
    private func search(req: Request) async throws -> Page<Hotel> {
        guard let term = req.query[String.self, at: "q"]?.lowercased() else {
            throw Abort(.badRequest)
        }
        
        return try await Hotel.query(on: req.db)
            .group(.or) { group in
                group.filter(\.$name ~~ term)
                    .filter(\.$location ~~ term)
                    .filter(\.$description ~~ term)
            }
            .paginate(for: req)
    }
    
    // Toggle favorite status (requires authentication)
    private func toggleFavorite(req: Request) async throws -> HTTPStatus {
        // Implementation for favoriting hotels
        return .ok
    }
} 