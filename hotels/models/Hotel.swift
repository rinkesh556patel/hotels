import Foundation

struct Hotel: Identifiable, Codable {
    let id: UUID?
    let name: String
    let location: String
    let description: String
    let pricePerNight: Double
    let rating: Double
    let amenities: [String]
    let imageURLs: [String]
}
