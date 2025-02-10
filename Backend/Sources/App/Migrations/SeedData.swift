import Fluent
import Vapor

struct SeedData: AsyncMigration {
    func prepare(on database: Database) async throws {
    // Create hotels first
        let hotel1 = Hotel(
            name: "Grand Plaza Hotel",
            location: "New York",
            description: "Luxury hotel in the heart of Manhattan",
            pricePerNight: 299.0,
            rating: 4.5,
            amenities: [
                "Luxury Spa", "Indoor Pool", "Fitness Center", "Fine Dining Restaurant",
                "Business Center", "Conference Rooms", "Beach Access", "Outdoor Pool", 
                "Tennis Courts", "Garden", "BBQ Area", "Rooftop Lounge"
            ],
            imageURLs: ["https://images.freeimages.com/images/large-previews/17f/modern-hotel-bedroom-0410-5706616.jpg"]
        )
        try await hotel1.save(on: database)
        
        // Then create rooms for this hotel
        let hotel1Rooms = [
            Room(hotelID: try hotel1.requireID(), type: "Standard", price: 299.0, capacity: 2),
            Room(hotelID: try hotel1.requireID(), type: "Deluxe", price: 399.0, capacity: 2),
            Room(hotelID: try hotel1.requireID(), type: "Executive Suite", price: 599.0, capacity: 3),
            Room(hotelID: try hotel1.requireID(), type: "Family Suite", price: 799.0, capacity: 4),
            Room(hotelID: try hotel1.requireID(), type: "Presidential Suite", price: 1499.0, capacity: 6)
        ]
        
        for room in hotel1Rooms {
            try await room.save(on: database)
        }
        
        let hotel2 = Hotel(
            name: "Ocean View Resort",
            location: "Miami",
            description: "Beachfront resort with stunning views",
            pricePerNight: 199.0,
            rating: 4.2,
            amenities: [
                "Beachfront Spa", "Indoor Pool", "Fitness Center", "Seafood Restaurant",
                "Kids Club", "Game Room", "Private Beach", "Beach Cabanas", 
                "Water Sports Center", "Infinity Pool", "Beach Volleyball", "Outdoor Yoga"
            ],
            imageURLs: ["https://images.freeimages.com/images/large-previews/9d3/hotel-1217956.jpg"]
        )
        try await hotel2.save(on: database)
        
        let hotel2Rooms = [
            Room(hotelID: try hotel2.requireID(), type: "Ocean View Room", price: 199.0, capacity: 2),
            Room(hotelID: try hotel2.requireID(), type: "Beach Suite", price: 299.0, capacity: 2),
            Room(hotelID: try hotel2.requireID(), type: "Family Beach Villa", price: 499.0, capacity: 4),
            Room(hotelID: try hotel2.requireID(), type: "Luxury Suite", price: 699.0, capacity: 3),
            Room(hotelID: try hotel2.requireID(), type: "Presidential Beach Villa", price: 1299.0, capacity: 6)
        ]
        
        for room in hotel2Rooms {
            try await room.save(on: database)
        }
        
       // Third Hotel
        let hotel3 = Hotel(
            name: "The Ritz Palace",
            location: "Dubai",
            description: "Ultra-luxury hotel with world-class amenities and spectacular city views",
            pricePerNight: 599.0,
            rating: 4.8,
            amenities: [
                "Luxury Spa", "Indoor Pool", "High-end Fitness Center", 
                "Michelin Star Restaurant", "Executive Lounge", "Gold Lounge", 
                "Cinema", "Indoor Garden", "Infinity Pool", "Private Beach", 
                "Tennis Courts", "Rooftop Lounge", "Desert Garden", 
                "Helicopter Pad", "Outdoor Dining"
            ],
            imageURLs: ["https://images.freeimages.com/images/large-previews/442/burj-al-arab-1222879.jpg"]
        )
        try await hotel3.save(on: database)
        
        let hotel3Rooms = [
            Room(hotelID: try hotel3.requireID(), type: "Deluxe Room", price: 599.0, capacity: 2),
            Room(hotelID: try hotel3.requireID(), type: "Club Suite", price: 899.0, capacity: 2),
            Room(hotelID: try hotel3.requireID(), type: "Royal Suite", price: 1499.0, capacity: 4),
            Room(hotelID: try hotel3.requireID(), type: "Family Palace Suite", price: 2499.0, capacity: 6),
            Room(hotelID: try hotel3.requireID(), type: "Royal Penthouse", price: 4999.0, capacity: 8)
        ]
        
        for room in hotel3Rooms {
            try await room.save(on: database)
        }

        // Fourth Hotel
        let hotel4 = Hotel(
            name: "Heritage Gateway Hotel",
            location: "Mumbai",
            description: "Historic luxury hotel with colonial charm and modern amenities",
            pricePerNight: 249.0,
            rating: 4.6,
            amenities: [
                "Ayurvedic Spa", "Indoor Pool", "Heritage Museum", 
                "Fine Dining Restaurant", "Tea Lounge", "Yoga Studio", 
                "Business Center", "Art Gallery", "Heritage Garden", 
                "Poolside Dining", "Meditation Garden", "Courtyard", 
                "Rooftop Lounge", "Historic Walking Trail"
            ],
            imageURLs: ["https://media.istockphoto.com/id/2162071973/photo/mumbais-famous-heritage-landmark-gateway-of-india"]
        )
        try await hotel4.save(on: database)
        
        let hotel4Rooms = [
            Room(hotelID: try hotel4.requireID(), type: "Heritage Room", price: 249.0, capacity: 2),
            Room(hotelID: try hotel4.requireID(), type: "Colonial Suite", price: 399.0, capacity: 2),
            Room(hotelID: try hotel4.requireID(), type: "Royal Chamber", price: 599.0, capacity: 3),
            Room(hotelID: try hotel4.requireID(), type: "Maharaja Suite", price: 899.0, capacity: 4),
            Room(hotelID: try hotel4.requireID(), type: "Presidential Palace Suite", price: 1499.0, capacity: 6)
        ]
        
        for room in hotel4Rooms {
            try await room.save(on: database)
        }
    }

    func revert(on database: Database) async throws {
        try await Room.query(on: database).delete()
        try await Hotel.query(on: database).delete()
    }
} 