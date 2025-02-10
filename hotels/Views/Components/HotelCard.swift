
import SwiftUI

struct HotelCard: View {
    let hotel: Hotel
    
    var body: some View {
        NavigationLink(destination: HotelDetailView(hotel: hotel)) {
            VStack(alignment: .leading, spacing: 8) {
                // Image
                AsyncImage(url: URL(string: hotel.imageURLs.first ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(height: 200)
                .clipped()
                .cornerRadius(12)
                
                // Hotel Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(hotel.name)
                        .font(.headline)
                    
                    Text(hotel.location)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Label("\(hotel.rating, specifier: "%.1f")", systemImage: "star.fill")
                            .foregroundColor(.yellow)
                        
                        Spacer()
                        
                        Text("$\(Int(hotel.pricePerNight))/night")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)
        }
    }
}
