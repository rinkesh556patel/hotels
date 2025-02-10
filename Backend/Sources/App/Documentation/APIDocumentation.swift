import Vapor

struct APIDocumentation {
    static let description = """
    # Hotel Management API
    
    ## Authentication
    
    ### POST /auth/register
    Register a new user
    ```json
    {
        "name": "John Doe",
        "email": "john@example.com",
        "password": "securepassword"
    }
    ```
    
    ### POST /auth/login
    Login and receive JWT token
    ```json
    {
        "email": "john@example.com",
        "password": "securepassword"
    }
    ```
    
    ## Hotels
    
    ### GET /hotels
    List all hotels with optional filters
    - Query parameters:
        - minPrice: Double
        - maxPrice: Double
        - minRating: Double
        - location: String
    
    ### GET /hotels/search
    Search hotels
    - Query parameters:
        - q: String (search term)
    
    ### GET /hotels/:hotelID
    Get hotel details
    
    ### GET /hotels/:hotelID/rooms
    Get rooms for a specific hotel
    
    ## Bookings
    
    ### GET /bookings
    List user's bookings
    
    ### POST /bookings
    Create a new booking
    ```json
    {
        "room_id": "uuid",
        "check_in": "2024-03-20T00:00:00Z",
        "check_out": "2024-03-25T00:00:00Z"
    }
    ```
    
    ### PATCH /bookings/:bookingID
    Update booking status
    ```json
    {
        "status": "cancelled"
    }
    ```
    
    ### DELETE /bookings/:bookingID
    Cancel booking
    """
} 