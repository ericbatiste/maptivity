import SwiftUI

struct AuthRouter: View {
    private var authManager = ""
    
    var body: some View {
        Group {
            if authManager == "loading" {
                LoadingView()
            } else if authManager == "authenticated" {
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

#Preview {
    AuthRouter()
}
