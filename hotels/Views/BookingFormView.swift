import SwiftUI

struct BookingFormView: View {
    let room: Room
    let hotel: Hotel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: BookingFormViewModel
    @EnvironmentObject var authManager: AuthManager
    
    init(room: Room, hotel: Hotel) {
        self.room = room
        self.hotel = hotel
        _viewModel = StateObject(wrappedValue: BookingFormViewModel(room: room))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !authManager.isAuthenticated {
                    notAuthenticatedView
                } else {
                    bookingFormContent
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var notAuthenticatedView: some View {
        VStack {
            Text("Please sign in to book a room")
            NavigationLink("Sign In", destination: LoginView())
        }
    }
    
    private var bookingFormContent: some View {
        Form {
            dateSection
            detailsSection
            bookingButton
        }
        .navigationTitle("Book Room")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            cancelButton
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
        .alert("Booking Confirmed", isPresented: $viewModel.showSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your booking has been confirmed successfully!")
        }
    }
    
    private var dateSection: some View {
        Section("Dates") {
            DatePicker(
                "Check In",
                selection: $viewModel.checkInDate,
                in: Date()...,
                displayedComponents: .date
            )
            
            DatePicker(
                "Check Out",
                selection: $viewModel.checkOutDate,
                in: viewModel.checkInDate...,
                displayedComponents: .date
            )
        }
    }
    
    private var detailsSection: some View {
        Section("Details") {
            roomTypeRow
            priceRow
            nightsRow
            totalPriceRow
        }
    }
    
    private var roomTypeRow: some View {
        HStack {
            Text("Room Type")
            Spacer()
            Text(room.type)
                .foregroundColor(.secondary)
        }
    }
    
    private var priceRow: some View {
        HStack {
            Text("Price per night")
            Spacer()
            Text("$\(room.price, specifier: "%.2f")")
                .foregroundColor(.secondary)
        }
    }
    
    private var nightsRow: some View {
        HStack {
            Text("Total nights")
            Spacer()
            Text("\(viewModel.numberOfNights)")
                .foregroundColor(.secondary)
        }
    }
    
    private var totalPriceRow: some View {
        HStack {
            Text("Total Price")
            Spacer()
            Text("$\(viewModel.totalPrice, specifier: "%.2f")")
                .fontWeight(.bold)
        }
    }
    
    private var bookingButton: some View {
        Section {
            Button(action: {
                Task {
                    await viewModel.createBooking()
                }
            }) {
                Text("Confirm Booking")
                    .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.isLoading)
        }
    }
    
    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
                dismiss()
            }
        }
    }
}

class BookingFormViewModel: ObservableObject {
    @Published var checkInDate = Date()
    @Published var checkOutDate = Date().addingTimeInterval(24 * 60 * 60)
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var showSuccess = false
    
    private let room: Room
    private let bookingService = BookingService.shared
    
    init(room: Room) {
        self.room = room
    }
    
    var numberOfNights: Int {
        Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate).day ?? 1
    }
    
    var totalPrice: Double {
        Double(numberOfNights) * room.price
    }
    
    @MainActor
    func createBooking() async {
        isLoading = true
        do {
            _ = try await bookingService.createBooking(
                roomId: room.id!,
                checkIn: checkInDate,
                checkOut: checkOutDate,
                price: totalPrice  // Add this parameter
            )
            showSuccess = true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
