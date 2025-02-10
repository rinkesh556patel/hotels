import SwiftUI

struct BookingCard: View {
    let booking: Booking
    @StateObject private var viewModel = BookingsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(booking.hotelName)
                        .font(.headline)
                    Text(booking.roomType)
                        .foregroundColor(.secondary)
                }
                Spacer()
                StatusBadge(status: booking.status)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Label {
                        Text(booking.checkIn.formatted(date: .abbreviated, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    Label {
                        Text(booking.checkOut.formatted(date: .abbreviated, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
                
                Spacer()
                
                Text("$\(booking.totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            if booking.status == .upcoming {
                Button(role: .destructive) {
                    Task {
                        await viewModel.cancelBooking(id: booking.id!)
                    }
                } label: {
                    Text("Cancel Booking")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
