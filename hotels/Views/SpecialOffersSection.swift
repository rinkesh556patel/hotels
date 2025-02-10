//
//  SpecialOffersSection.swift
//  hotels
//
//  Created by rinkesh patel on 09/02/25.
//


import SwiftUI

struct SpecialOffersSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Special Offers")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<3) { _ in
                        OfferCard()
                    }
                }
            }
        }
    }
}

struct OfferCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 250, height: 100)
                .cornerRadius(8)
                .overlay(
                    VStack {
                        Text("Special Offer")
                            .font(.headline)
                        Text("Up to 30% off")
                            .font(.subheadline)
                    }
                )
        }
    }
} 