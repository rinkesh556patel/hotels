//
//  StatusBadge.swift
//  hotels
//
//  Created by rinkesh patel on 09/02/25.
//


import SwiftUI

struct StatusBadge: View {
    let status: BookingStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .upcoming:
            return .blue
        case .completed:
            return .green
        case .cancelled:
            return .red
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        StatusBadge(status: .upcoming)
        StatusBadge(status: .completed)
        StatusBadge(status: .cancelled)
    }
    .padding()
}