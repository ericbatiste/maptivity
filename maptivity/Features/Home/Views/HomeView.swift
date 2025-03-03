import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Home Screen!")
                    .padding()
                
                Spacer()
                
                Button {
                    Task {
                        await authManager.logout()
                    }
                } label: {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .frame(minWidth: 100)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Home")
        }
    }
}
