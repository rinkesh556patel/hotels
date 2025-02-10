import Foundation

struct Room: Identifiable, Codable {
    let id: UUID?
    let type: String
    let price: Double
    let capacity: Int
    let available: Bool
    let hotel: HotelReference
    
    // Computed property to get hotelID
    var hotelID: UUID {
        hotel.id
    }
}

struct HotelReference: Codable {
    let id: UUID
}