import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var isSignUp = false
    @State private var acceptedPrivacy = false
    @State private var showPrivacyPolicy = false
    @State private var showError = false
    
    var body: some View {
        ZStack {
            GalaxyBackgroundView()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Logo/Title
                VStack(spacing: 10) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 80))
                        .foregroundColor(.cyan)
                    Text("Color Nova")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.cyan)
                    Text("Match the Galaxy")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.bottom, 40)
                
                // Input fields
                VStack(spacing: 15) {
                    if isSignUp {
                        TextField("Name", text: $name)
                            .textFieldStyle(GalaxyTextFieldStyle())
                            .textContentType(.name)
                            .autocapitalization(.words)
                    }
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(GalaxyTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(GalaxyTextFieldStyle())
                        .textContentType(isSignUp ? .newPassword : .password)
                    
                    if isSignUp {
                        HStack {
                            Button(action: {
                                acceptedPrivacy.toggle()
                            }) {
                                Image(systemName: acceptedPrivacy ? "checkmark.square.fill" : "square")
                                    .foregroundColor(acceptedPrivacy ? .green : .white.opacity(0.6))
                                    .font(.title3)
                            }
                            
                            Button(action: {
                                showPrivacyPolicy = true
                            }) {
                                Text("I accept the Privacy Policy")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.8))
                                    .underline()
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal, 30)
                
                // Action button - NO SHADOW
                Button(action: {
                    handleAuth()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text(isSignUp ? "Sign Up" : "Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(
                    LinearGradient(
                        colors: [.cyan, .blue],  // Less purple
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .padding(.horizontal, 30)
                .disabled(viewModel.isLoading || (isSignUp && !acceptedPrivacy))
                .opacity((isSignUp && !acceptedPrivacy) ? 0.5 : 1.0)
                
                // Toggle Sign In/Sign Up
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "An error occurred")
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                PrivacyPolicyView()
            }
        }
    }
    
    private func handleAuth() {
        Task {
            if isSignUp {
                await viewModel.signUp(email: email, password: password, name: name)
            } else {
                await viewModel.signIn(email: email, password: password)
            }
            
            if viewModel.errorMessage != nil {
                showError = true
            }
        }
    }
}

struct GalaxyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.white)
            .accentColor(.cyan)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    AuthView()
}
