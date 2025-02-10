import Foundation

class HotelService {
    static let shared = HotelService()
    private let api = APIClient.shared
    
    private init() {}
    
    func getHotels(minPrice: Double? = nil, maxPrice: Double? = nil, minRating: Double? = nil) async throws -> [Hotel] {
        var queryItems: [String] = []
        
        if let minPrice = minPrice {
            queryItems.append("min_price=\(minPrice)")
        }
        if let maxPrice = maxPrice {
            queryItems.append("max_price=\(maxPrice)")
        }
        if let minRating = minRating {
            queryItems.append("min_rating=\(minRating)")
        }
        
        let path = "/hotels" + (queryItems.isEmpty ? "" : "?\(queryItems.joined(separator: "&"))")
        let endpoint = Endpoint(path: path)
        
        do {
            let response: PaginatedResponse<Hotel> = try await api.request(endpoint)
            return response.items
        } catch {
            print("❌ Hotel service error: \(error)")
            throw error
        }
    }
    
    func searchHotels(query: String) async throws -> [Hotel] {
        let endpoint = Endpoint(path: "/hotels/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")
        let response: PaginatedResponse<Hotel> = try await api.request(endpoint)
        return response.items
    }
    
    func getHotelDetails(id: UUID) async throws -> Hotel {
        let endpoint = Endpoint(path: "/hotels/\(id)")
        return try await api.request(endpoint)
    }
    
    func getRooms(hotelId: UUID) async throws -> [Room] {
        print("📍 Fetching rooms for hotel: \(hotelId)")
        let endpoint = Endpoint(path: "/hotels/\(hotelId)/rooms")
        do {
            let rooms: [Room] = try await api.request(endpoint)
            print("✅ Received \(rooms.count) rooms")
            return rooms
        } catch {
            print("❌ Error fetching rooms: \(error)")
            throw error
        }
    }
}
