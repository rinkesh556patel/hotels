
import SwiftUI

struct HotelDetailView: View {
    let hotel: Hotel
    @StateObject private var viewModel: HotelDetailViewModel
    @State private var selectedDates: ClosedRange<Date>?
    @State private var showingBookingSheet = false
    @State private var selectedRoom: Room?
    
    init(hotel: Hotel) {
        self.hotel = hotel
        _viewModel = StateObject(wrappedValue: HotelDetailViewModel(hotelId: hotel.id!))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Images
                TabView {
                    ForEach(hotel.imageURLs, id: \.self) { urlString in
                        AsyncImage(url: URL(string: urlString)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                VStack(alignment: .leading, spacing: 8) {
                    // Hotel Info
                    Text(hotel.name)
                        .font(.title)
                    
                    Text(hotel.location)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Label("\(hotel.rating, specifier: "%.1f")", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        Text("(\(Int.random(in: 100...500)) reviews)")
                            .foregroundColor(.gray)
                    }
                    
                    // Description
                    Text(hotel.description)
                        .padding(.vertical)
                    
                    // Amenities
                    Text("Amenities")
                        .font(.headline)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), alignment: .leading)]) {
                        ForEach(hotel.amenities, id: \.self) { amenity in
                            Label(amenity, systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    // Available Rooms Section
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Available Rooms")
                                .font(.headline)
                            
                            ForEach(viewModel.rooms) { room in
                                NavigationLink(destination: RoomDetailView(room: room, hotel: hotel)) {
                                    RoomCard(room: room)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error occurred")
        }
    }
}

class HotelDetailViewModel: ObservableObject {
    @Published var rooms: [Room] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let hotelService = HotelService.shared
    private let hotelId: UUID
    
    init(hotelId: UUID) {
        self.hotelId = hotelId
        print("🏨 HotelDetailViewModel initialized with hotelId: \(hotelId)")
        Task {
            await loadRooms()
        }
    }
    
    @MainActor
    func loadRooms() async {
        isLoading = true
        do {
            print("🔄 Starting to load rooms")
            rooms = try await hotelService.getRooms(hotelId: hotelId)
            print("✅ Loaded \(rooms.count) rooms")
            if !rooms.isEmpty {
                rooms.forEach { room in
                    print("📝 Room: type=\(room.type), price=\(room.price), available=\(room.available)")
                }
            }
        } catch {
            print("❌ Error in ViewModel: \(error)")
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
