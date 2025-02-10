import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            BookingsView()
                .tabItem {
                    Label("Bookings", systemImage: "calendar")
                }
            
            if authManager.isAuthenticated {
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            } else {
                LoginView()
                    .tabItem {
                        Label("Sign In", systemImage: "person")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager.shared)
} 