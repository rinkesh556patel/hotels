import Foundation

struct Booking: Identifiable, Codable {
    let id: UUID?
    let userID: UUID
    let roomID: UUID
    let checkIn: Date
    let checkOut: Date
    let totalPrice: Double
    let status: BookingStatus
    let room: RoomDetails?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userID
        case roomID
        case user
        case room
        case checkIn
        case checkOut
        case totalPrice
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id)
        
        // Try to decode userID directly first, if not present try nested user object
        if let directUserID = try? container.decode(UUID.self, forKey: .userID) {
            userID = directUserID
        } else {
            let user = try container.decode(UserReference.self, forKey: .user)
            userID = user.id
        }
        
        // Try to decode roomID directly first, if not present try nested room object
        if let directRoomID = try? container.decode(UUID.self, forKey: .roomID) {
            roomID = directRoomID
        } else {
            let roomRef = try container.decode(RoomReference.self, forKey: .room)
            roomID = roomRef.id
        }
        
        checkIn = try container.decode(Date.self, forKey: .checkIn)
        checkOut = try container.decode(Date.self, forKey: .checkOut)
        totalPrice = try container.decode(Double.self, forKey: .totalPrice)
        status = try container.decode(BookingStatus.self, forKey: .status)
        room = try? container.decode(RoomDetails.self, forKey: .room)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(UserReference(id: userID), forKey: .user)
        try container.encode(RoomReference(id: roomID), forKey: .room)
        try container.encode(checkIn, forKey: .checkIn)
        try container.encode(checkOut, forKey: .checkOut)
        try container.encode(totalPrice, forKey: .totalPrice)
        try container.encode(status, forKey: .status)
    }
}

struct RoomDetails: Codable {
    let id: UUID
    let type: String
    let price: Double
    let hotel: HotelDetails
}

struct HotelDetails: Codable {
    let id: UUID
    let name: String
    let location: String
}

enum BookingStatus: String, Codable {
    case upcoming
    case completed
    case cancelled
}

// Helper computed properties
extension Booking {
    var hotelName: String {
        room?.hotel.name ?? "Unknown Hotel"
    }
    
    var roomType: String {
        room?.type ?? "Unknown Room"
    }
    
    var roomPrice: Double {
        room?.price ?? 0.0
    }
} 
