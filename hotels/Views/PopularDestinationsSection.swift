//
//  PopularDestinationsSection.swift
//  hotels
//
//  Created by rinkesh patel on 09/02/25.
//


import SwiftUI

struct PopularDestinationsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular Destinations")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<5) { _ in
                        DestinationCard()
                    }
                }
            }
        }
    }
}

struct DestinationCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 150, height: 150)
                .cornerRadius(75)
            
            Text("Destination Name")
                .font(.subheadline)
                .frame(width: 150)
        }
    }
} 