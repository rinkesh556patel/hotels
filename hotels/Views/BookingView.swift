import SwiftUI

struct BookingView: View {
    let room: Room
    let hotel: Hotel
    @StateObject private var viewModel: BookingViewModel
    @Environment(\.dismiss) var dismiss
    
    init(room: Room, hotel: Hotel) {
        self.room = room
        self.hotel = hotel
        _viewModel = StateObject(wrappedValue: BookingViewModel(roomPrice: room.price))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Dates")) {
                    DatePicker("Check-in", selection: $viewModel.checkInDate, in: Date()..., displayedComponents: .date)
                    DatePicker("Check-out", selection: $viewModel.checkOutDate, in: viewModel.checkInDate..., displayedComponents: .date)
                }
                
                Section(header: Text("Room Details")) {
                    HStack {
                        Text("Room Type")
                        Spacer()
                        Text(room.type)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Capacity")
                        Spacer()
                        Text("\(room.capacity) guests")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Price per night")
                        Spacer()
                        Text("$\(Int(room.price))")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Total")) {
                    HStack {
                        Text("Total nights")
                        Spacer()
                        Text("\(viewModel.numberOfNights)")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Total price")
                        Spacer()
                        Text("$\(viewModel.totalPrice)")
                            .bold()
                    }
                }
            }
            .navigationTitle("Book Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Book") {
                        Task {
                            await viewModel.createBooking(roomId: room.id!)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error occurred")
            }
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your booking has been confirmed!")
            }
        }
    }
}

class BookingViewModel: ObservableObject {
    @Published var checkInDate = Date()
    @Published var checkOutDate = Date().addingTimeInterval(24 * 60 * 60)
    @Published var isLoading = false
    @Published var showError = false
    @Published var showSuccess = false
    @Published var errorMessage: String?
    
    private let bookingService = BookingService.shared
    private let roomPrice: Double
    
    init(roomPrice: Double) {
        self.roomPrice = roomPrice
    }
    
    var numberOfNights: Int {
        Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate).day ?? 0
    }
    
    var totalPrice: Int {
        numberOfNights * Int(roomPrice)
    }
    
    @MainActor
    func createBooking(roomId: UUID) async {
        isLoading = true
        do {
            _ = try await bookingService.createBooking(
                roomId: roomId,
                checkIn: checkInDate,
                checkOut: checkOutDate,
                price: Double(totalPrice)
            )
            showSuccess = true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
