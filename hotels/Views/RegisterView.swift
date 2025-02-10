import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $viewModel.name)
                    .textContentType(.name)
                
                TextField("Email", text: $viewModel.email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                    .textContentType(.newPassword)
            }
            
            Button(action: {
                Task {
                    await viewModel.register()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Create Account")
                }
            }
            .frame(maxWidth: .infinity)
            .disabled(viewModel.isLoading)
        }
        .navigationTitle("Create Account")
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
    }
}

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    private let authManager = AuthManager.shared
    
    func register() async {
        guard !name.isEmpty && !email.isEmpty && !password.isEmpty else {
            showError = true
            errorMessage = "Please fill in all fields"
            return
        }
        
        isLoading = true
        do {
            try await authManager.register(name: name, email: email, password: password)
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
    NavigationView {
        RegisterView()
    }
} 
