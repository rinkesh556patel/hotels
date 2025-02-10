import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                }
                
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
                    }
                }
                .frame(maxWidth: .infinity)
                .disabled(viewModel.isLoading)
                
                NavigationLink("Create Account", destination: RegisterView())
            }
            .navigationTitle("Sign In")
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }
}

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let authManager = AuthManager.shared
    
    func login() async {
        guard !email.isEmpty && !password.isEmpty else {
            showError = true
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        do {
            try await authManager.login(email: email, password: password)
        } catch let error as APIError {
            showError = true
            errorMessage = error.errorDescription
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager.shared)
} 
