import Fluent
import Vapor

final class Booking: Model, Content {
    static let schema = "bookings"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "room_id")
    var room: Room
    
    @Field(key: "check_in")
    var checkIn: Date
    
    @Field(key: "check_out")
    var checkOut: Date
    
    @Field(key: "total_price")
    var totalPrice: Double
    
    @Field(key: "status")
    var status: BookingStatus
    
    init() {}
    
    init(id: UUID? = nil, userID: UUID, roomID: UUID, checkIn: Date, 
         checkOut: Date, totalPrice: Double, status: BookingStatus = .upcoming) {
        self.id = id
        self.$user.id = userID
        self.$room.id = roomID
        self.checkIn = checkIn
        self.checkOut = checkOut
        self.totalPrice = totalPrice
        self.status = status
    }
}

extension Booking: @unchecked Sendable {}

enum BookingStatus: String, Codable {
    case upcoming
    case completed
    case cancelled
} 