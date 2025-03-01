import SwiftUI

struct SignUpView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text("Submit Form to Sign Up")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("Name", text: $name)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .tint(.blue)
                    
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
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .tint(.blue)
                    
                    Button(action: {}) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 32)
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
    }
}
