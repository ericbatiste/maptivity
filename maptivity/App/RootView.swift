import SwiftUI

struct RootView: View {
    @EnvironmentObject var apiService: APIService
    
    @State private var selectedTab = 0
    
    init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemGray6
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            NavigationStack {
                RecordView(selectedTab: $selectedTab)
            }
            .tabItem {
                Image(systemName: "record.circle")
                Text("Record")
            }
            .tag(1)
            
            ActivityView(viewModel: ActivityViewModel(apiService: apiService))
                .tabItem {
                    Image(systemName: "point.topleft.down.to.point.bottomright.filled.curvepath")
                    Text("Activity")
                }
                .tag(2)
        }
    }
}

//#Preview {
//    let tokenManager = TokenManager()
//    let apiService = APIService(tokenManager: tokenManager)
//    
//    RootView()
//        .environmentObject(apiService)
//}
