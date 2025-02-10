//
//  FeaturedHotelsSection.swift
//  hotels
//
//  Created by rinkesh patel on 09/02/25.
//


import SwiftUI

struct FeaturedHotelsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Featured Hotels")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        FeaturedHotelCard()
                    }
                }
            }
        }
    }
}

struct FeaturedHotelCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 200, height: 120)
                .cornerRadius(8)
            
            Text("Hotel Name")
                .font(.headline)
            Text("Location")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("$199/night")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .frame(width: 200)
    }
} 