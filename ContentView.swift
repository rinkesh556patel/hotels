import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "calendar")
                }
            
            ServicesView()
                .tabItem {
                    Label("Services", systemImage: "bell.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
} 