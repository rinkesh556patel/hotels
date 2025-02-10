//
//  ServicesView.swift
//  hotels
//
//  Created by rinkesh patel on 09/02/25.
//


import SwiftUI

struct ServicesView: View {
    let services = [
        "Room Service",
        "Housekeeping",
        "Concierge",
        "Restaurant Reservations",
        "Spa Services",
        "Airport Transfer"
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(services, id: \.self) { service in
                    NavigationLink(destination: ServiceDetailView(serviceName: service)) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(service)
                        }
                    }
                }
            }
            .navigationTitle("Hotel Services")
        }
    }
}

struct ServiceDetailView: View {
    let serviceName: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Book \(serviceName)")
                .font(.title)
            
            Button("Request Service") {
                // Handle service request
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
} 