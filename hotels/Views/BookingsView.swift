import SwiftUI

struct BookingsView: View {
    @StateObject private var viewModel = BookingsViewModel()
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            Group {
                if !viewModel.isAuthenticated {
                    VStack(spacing: 20) {
                        Text("Sign in to view your bookings")
                            .font(.headline)
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.bookings.isEmpty {
                    ContentUnavailableView(
                        "No Bookings",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("You haven't made any bookings yet")
                    )
                } else {
                    List(viewModel.bookings) { booking in
                        BookingCard(booking: booking)
                    }
                }
            }
            .navigationTitle("My Bookings")
        }
        .onAppear {
            viewModel.setAuthenticated(authManager.isAuthenticated)
        }
        .onChange(of: authManager.isAuthenticated) { newValue in
            viewModel.setAuthenticated(newValue)
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
    }
}

class BookingsViewModel: ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let bookingService = BookingService.shared
    
    init() {
        Task {
            await loadBookings()
        }
    }
    
    @MainActor
    func loadBookings() async {
        isLoading = true
        do {
            bookings = try await bookingService.getBookings()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func cancelBooking(id: UUID) async {
        do {
            try await bookingService.cancelBooking(id: id)
            await loadBookings()
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func setAuthenticated(_ authenticated: Bool) {
        isAuthenticated = authenticated
        if authenticated {
            Task {
                await loadBookings()
            }
        } else {
            bookings = []
        }
    }
} 
