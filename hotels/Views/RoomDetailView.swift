//
//  RoomDetailView.swift
//  hotels
//
//  Created by rinkesh patel on 10/02/25.
//


import SwiftUI

struct RoomDetailView: View {
    let room: Room
    let hotel: Hotel
    @State private var showingBookingForm = false
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Room Images
                if let firstImage = hotel.imageURLs.first {
                    AsyncImage(url: URL(string: firstImage)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                    }
                    .frame(height: 250)
                    .clipped()
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Room Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(room.type)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(hotel.name)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(hotel.location)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Room Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Room Details")
                            .font(.headline)
                        
                        HStack {
                            RoomDetailItem(
                                icon: "person.2.fill",
                                title: "Capacity",
                                value: "\(room.capacity) Guests"
                            )
                            
                            Spacer()
                            
                            RoomDetailItem(
                                icon: "bed.double.fill",
                                title: "Room Type",
                                value: room.type
                            )
                        }
                        
                        RoomDetailItem(
                            icon: "dollarsign.circle.fill",
                            title: "Price per night",
                            value: "$\(room.price)"
                        )
                    }
                    
                    Divider()
                    
                    // Hotel Amenities
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hotel Amenities")
                            .font(.headline)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(hotel.amenities, id: \.self) { amenity in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(amenity)
                                        .font(.subheadline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Book Now Button
                    if authManager.isAuthenticated {
                        Button(action: {
                            showingBookingForm = true
                        }) {
                            Text("Book Now")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    } else {
                        NavigationLink(destination: LoginView()) {
                            Text("Sign in to Book")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingBookingForm) {
            BookingFormView(room: room, hotel: hotel)
        }
    }
}

// Helper view for room details
struct RoomDetailItem: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}
