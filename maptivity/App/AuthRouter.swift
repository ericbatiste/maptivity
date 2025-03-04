import SwiftUI

struct AuthRouter: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isLoading {
                LoadingView()
            } else if authManager.isAuthenticated {
                RootView()
            } else {
                LoginView()
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .padding(.top)
        }
    }
}
