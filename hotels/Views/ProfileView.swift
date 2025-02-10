import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        Section {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.blue)
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.user?.name ?? "Loading...")
                                        .font(.headline)
                                    Text(viewModel.user?.email ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        
                        Section(header: Text("Preferences")) {
                            NavigationLink("Personal Information") {
                                Text("Personal Information View")
                            }
                            NavigationLink("Payment Methods") {
                                Text("Payment Methods View")
                            }
                            NavigationLink("Notifications") {
                                Text("Notifications View")
                            }
                        }
                        
                        Section {
                            Button("Sign Out") {
                                authManager.signOut()
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .alert("Error", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                }
            }
            .refreshable {
                await viewModel.loadUserProfile()
            }
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let userService = UserService.shared
    
    @MainActor
    func loadUserProfile() async {
        print("Loading user profile...")
        isLoading = true
        do {
            user = try await userService.getCurrentUser()
            print("User loaded: \(String(describing: user))")
        } catch {
            self.error = error
            print("Error loading user: \(error)")
        }
        isLoading = false
    }
    
    init() {
        print("ProfileViewModel initialized")
        Task {
            await loadUserProfile()
        }
    }
}
