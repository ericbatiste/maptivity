import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            RecordView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "record.circle")
                    Text("Record")
                }
                .toolbar(.hidden, for: .tabBar)
                .tag(1)
            
            ActivityView()
                .tabItem {
                    Image(systemName: "point.topleft.down.to.point.bottomright.filled.curvepath")
                    Text("Activity")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
