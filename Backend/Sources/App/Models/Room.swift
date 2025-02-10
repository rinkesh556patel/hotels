import Fluent
import Vapor

final class Room: Model, Content {
    static let schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "hotel_id")
    var hotel: Hotel
    
    @Field(key: "type")
    var type: String
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "capacity")
    var capacity: Int
    
    @Field(key: "available")
    var available: Bool
    
    init() {}
    
    init(id: UUID? = nil, hotelID: UUID, type: String, price: Double, capacity: Int, available: Bool = true) {
        self.id = id
        self.$hotel.id = hotelID
        self.type = type
        self.price = price
        self.capacity = capacity
        self.available = available
    }
}

extension Room: @unchecked Sendable {} 