import Foundation

class BookingService {
    static let shared = BookingService()
    private let api = APIClient.shared
    
    private init() {}
    
    func createBooking(roomId: UUID, checkIn: Date, checkOut: Date, price: Double) async throws -> Booking {
        print("Creating booking with roomId: \(roomId)")
        print("Check-in: \(checkIn)")
        print("Check-out: \(checkOut)")
        print("Total Price: \(price)")
        
        guard AuthManager.shared.isAuthenticated,
              let userId = AuthManager.shared.userId else {
            throw APIError.unauthorized
        }
        
        let booking = CreateBookingRequest(
            roomId: roomId,
            userId: userId,
            checkIn: checkIn,
            checkOut: checkOut,
            price: price
        )
        let endpoint = Endpoint(
            path: "/bookings",
            method: .post,
            body: booking
        )
        
        return try await api.request(endpoint)
    }

    func getBookings() async throws -> [Booking] {
        let endpoint = Endpoint(path: "/bookings")
        print("in getBookings ----->", endpoint)
        return try await api.request(endpoint)
    }
    
    func cancelBooking(id: UUID) async throws {
        let endpoint = Endpoint(
            path: "/bookings/\(id)",
            method: .delete
        )
        let _: EmptyResponse = try await api.request(endpoint)
    }
}

struct CreateBookingRequest: Codable {
    let room: RoomReference
    let user: UserReference
    let checkIn: Date
    let checkOut: Date
    let totalPrice: Double
    let status: BookingStatus
    
    init(roomId: UUID, userId: UUID, checkIn: Date, checkOut: Date, price: Double) {
        self.room = RoomReference(id: roomId)
        self.user = UserReference(id: userId)
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.totalPrice = price
        self.status = .upcoming
    }
    
    enum CodingKeys: String, CodingKey {
        case room
        case user
        case checkIn = "checkIn"
        case checkOut = "checkOut"
        case totalPrice = "totalPrice"
        case status
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(room, forKey: .room)
        try container.encode(user, forKey: .user)
        try container.encode(totalPrice, forKey: .totalPrice)
        try container.encode(status, forKey: .status)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        try container.encode(formatter.string(from: checkIn), forKey: .checkIn)
        try container.encode(formatter.string(from: checkOut), forKey: .checkOut)
    }
}

struct UserReference: Codable {  // Add this
    let id: UUID
}

struct RoomReference: Codable {
    let id: UUID
}

struct EmptyResponse: Codable {}
