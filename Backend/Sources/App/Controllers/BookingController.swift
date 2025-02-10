import Vapor
import Fluent

struct BookingController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bookings = routes.grouped("bookings")
            .grouped(JWTAuthenticator())
        
        bookings.get(use: index)
        bookings.post(use: create)
        bookings.get(":bookingID", use: show)
        bookings.patch(":bookingID", use: update)
        bookings.delete(":bookingID", use: delete)
    }
    
    // List user's bookings
    private func index(req: Request) async throws -> [BookingResponse] {
        let user = try req.auth.require(User.self)
        let bookings = try await Booking.query(on: req.db)
            .filter(\.$user.$id == user.id!)
            .all()
        
        // Use async sequence instead of map
        var responses: [BookingResponse] = []
        for booking in bookings {
            let response = try await BookingResponse(booking: booking, on: req.db)
            responses.append(response)
        }
        return responses
    }
    
    // Create new booking
    private func create(req: Request) async throws -> Booking {
        let user = try req.auth.require(User.self)
        let booking = try req.content.decode(Booking.self)
        
        // Validate room availability
        guard let room = try await Room.find(booking.$room.id, on: req.db),
              room.available else {
            throw Abort(.conflict, reason: "Room is not available")
        }
        
        // Check for date conflicts
        let conflictingBookings = try await Booking.query(on: req.db)
            .filter(\.$room.$id == room.id!)
            .filter(\.$status == .upcoming)
            .group(.or) { group in
                group.group(.and) { group in
                    group.filter(\.$checkIn <= booking.checkIn)
                        .filter(\.$checkOut >= booking.checkIn)
                }
                .group(.and) { group in
                    group.filter(\.$checkIn <= booking.checkOut)
                        .filter(\.$checkOut >= booking.checkOut)
                }
            }
            .count()
        
        guard conflictingBookings == 0 else {
            throw Abort(.conflict, reason: "Room is not available for selected dates")
        }
        
        booking.$user.id = try user.requireID()
        try await booking.save(on: req.db)
        return booking
    }
    
    // Get booking details
    private func show(req: Request) async throws -> Booking {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        guard let booking = try await Booking.find(req.parameters.get("bookingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard booking.$user.id == userID else {
            throw Abort(.notFound)
        }
        return booking
    }
    
    // Update booking
    private func update(req: Request) async throws -> Booking {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        guard let booking = try await Booking.find(req.parameters.get("bookingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard booking.$user.id == userID else {
            throw Abort(.notFound)
        }
        
        let update = try req.content.decode(BookingUpdate.self)
        
        if let newStatus = update.status {
            booking.status = newStatus
        }
        
        try await booking.save(on: req.db)
        return booking
    }
    
    // Cancel booking
    private func delete(req: Request) async throws -> HTTPStatus {
        let user = try req.auth.require(User.self)
        let userID = try user.requireID()
        
        guard let booking = try await Booking.find(req.parameters.get("bookingID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard booking.$user.id == userID else {
            throw Abort(.notFound)
        }
        
        booking.status = .cancelled
        try await booking.save(on: req.db)
        return .ok
    }
}

// DTO for updating bookings
struct BookingUpdate: Content {
    var status: BookingStatus?
}

struct BookingResponse: Content {
    let id: UUID?
    let userID: UUID
    let roomID: UUID
    let checkIn: Date
    let checkOut: Date
    let totalPrice: Double
    let status: String
    let room: RoomResponse?
    
    init(booking: Booking, on db: Database) async throws {
        self.id = booking.id
        self.userID = booking.$user.id
        self.roomID = booking.$room.id
        self.checkIn = booking.checkIn
        self.checkOut = booking.checkOut
        self.totalPrice = booking.totalPrice
        self.status = booking.status.rawValue
        
        // Load room and hotel details
        let room = try await booking.$room.get(on: db)
        let hotel = try await room.$hotel.get(on: db)
        self.room = RoomResponse(
            id: room.id!,
            type: room.type,
            price: room.price,
            hotel: HotelResponse(
                id: hotel.id!,
                name: hotel.name,
                location: hotel.location
            )
        )
    }
}

struct RoomResponse: Content {
    let id: UUID
    let type: String
    let price: Double
    let hotel: HotelResponse
}

struct HotelResponse: Content {
    let id: UUID
    let name: String
    let location: String
} 