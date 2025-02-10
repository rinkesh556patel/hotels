
import SwiftUI
struct RoomCard: View {
    let room: Room
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(room.type)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Capacity: \(room.capacity)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$\(room.price, specifier: "%.2f")")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("per night")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}
