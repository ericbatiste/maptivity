import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Text("Forgot password?")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("Email", text: $email)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .tint(.blue)
                    
                    Button(action: {}) {
                        Text("Send Reset Email")
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
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea()
        }
    }
}

