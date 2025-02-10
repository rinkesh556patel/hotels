
import SwiftUI

struct BookingDetailView: View {
    let booking: Booking
    @State private var showingModifyAlert = false
    @State private var showingCancelAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hotel Image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
                
                // Booking Details
                VStack(alignment: .leading, spacing: 16) {
                    Text(booking.hotelName)
                        .font(.title)
                        .bold()
                    
                    // Dates
                    VStack(alignment: .leading, spacing: 8) {
                        DateRow(title: "Check-in", date: booking.checkIn)
                        DateRow(title: "Check-out", date: booking.checkOut)
                    }
                    .padding(.vertical, 8)
                    
                    // Room Details
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Room Type")
                            .font(.headline)
                        Text(booking.roomType)
                            .foregroundColor(.gray)
                    }
                    
                    // Price
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Total Price")
                            .font(.headline)
                        Text("$\(String(format: "%.2f", booking.totalPrice))")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    // Status
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Status")
                            .font(.headline)
                        StatusBadge(status: booking.status)
                    }
                    
                    // Action Buttons
                    if booking.status == .upcoming {
                        VStack(spacing: 12) {
                            Button(action: { showingModifyAlert = true }) {
                                Label("Modify Booking", systemImage: "pencil")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            
                            Button(action: { showingCancelAlert = true }) {
                                Label("Cancel Booking", systemImage: "xmark.circle")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Booking Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Modify Booking", isPresented: $showingModifyAlert) {
            Button("OK") {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This feature will be available soon.")
        }
        .alert("Cancel Booking", isPresented: $showingCancelAlert) {
            Button("Yes, Cancel", role: .destructive) {
                // Handle cancellation
            }
            Button("No", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this booking? Cancellation fees may apply.")
        }
    }
}

struct DateRow: View {
    let title: String
    let date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(date, style: .date)
                .foregroundColor(.gray)
        }
    }
}
