import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email: String = ""
    @State private var password: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text("Howdy")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    TextField("Email", text: $email)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .tint(.blue)
                    
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .tint(.blue)
                    
                    Button {
                        Task {
                            await authManager.login(email: email, password: password)
                        }
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Don't have an account? Sign up!")
                    }
                    
                    NavigationLink(destination: ResetPasswordView()) {
                        Text("Forgot Password?")
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 32)
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
    }
}
