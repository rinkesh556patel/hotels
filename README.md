# Hotel Booking Application

## Overview
This is a Hotel Booking Application that allows users to search for hotels, make bookings, and manage their profiles. The application consists of a frontend built with SwiftUI and a backend built with Vapor.

## Tech Stack

### Frontend
- **Language**: Swift
- **Framework**: SwiftUI
- **State Management**: Combine
- **Networking**: URLSession for API calls
- **Dependency Management**: Swift Package Manager (SPM)

### Backend
- **Language**: Swift
- **Framework**: Vapor
- **Database**: PostgreSQL
- **Authentication**: JWT (JSON Web Tokens)
- **Middleware**: Custom middleware for authentication and error handling

## Features
- User authentication (sign up, sign in, sign out)
- View available hotels
- Make bookings for selected hotels
- View and manage user profile
- Responsive design for various devices

## Getting Started

### Prerequisites
- Swift 5.5 or later
- Xcode 13 or later (for iOS development)
- PostgreSQL 
- Vapor installed on your machine

### Frontend Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/rinkesh556patel/hotels.git
   cd hotels
   ```

2. Open the project in Xcode:
   ```bash
   open hotels.xcodeproj
   ```

3. Build and run the application on a simulator or a physical device.

### Backend Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/rinkesh556patel/hotels.git
   cd hotels/Backend
   ```

2. Install dependencies:
   ```bash
   vapor build
   ```

3. Set up the database:
   - Create a PostgreSQL database and update the database configuration in `config.json`.

4. Run the server:
   ```bash
   vapor run
   ```

5. The backend will be available at `http://localhost:8080`.

## API Endpoints
### Authentication
- **POST /auth/signup**: Create a new user account.
- **POST /auth/login**: Authenticate a user and return a JWT token.
- **GET /auth/me**: Retrieve the current user's profile.

### Bookings
- **GET /bookings**: Retrieve all bookings for the authenticated user.
- **POST /bookings**: Create a new booking.
- **DELETE /bookings/{id}**: Cancel a booking by ID.

### Hotels
- **GET /hotels**: Retrieve a list of available hotels.

## Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes and commit them (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Create a new Pull Request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- [Vapor](https://vapor.codes/) - The backend framework.
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) - The frontend framework.
- [PostgreSQL](https://www.postgresql.org/) - The database used for storage.
