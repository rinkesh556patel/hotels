import Fluent
import Vapor

final class Hotel: Model, Content {
    static let schema = "hotels"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "location")
    var location: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "price_per_night")
    var pricePerNight: Double
    
    @Field(key: "rating")
    var rating: Double
    
    @Field(key: "amenities")
    var amenities: [String]
    
    @Field(key: "image_urls")
    var imageURLs: [String]
    
    @Children(for: \.$hotel)
    var rooms: [Room]
    
    init() {}
    
    init(id: UUID? = nil, name: String, location: String, description: String,
         pricePerNight: Double, rating: Double, amenities: [String], imageURLs: [String]) {
        self.id = id
        self.name = name
        self.location = location
        self.description = description
        self.pricePerNight = pricePerNight
        self.rating = rating
        self.amenities = amenities
        self.imageURLs = imageURLs
    }
}

extension Hotel: @unchecked Sendable {} 