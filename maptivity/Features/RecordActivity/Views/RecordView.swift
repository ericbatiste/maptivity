import SwiftUI
import CoreLocation

struct RecordView: View {
    @EnvironmentObject var apiService: APIService
    
    @State private var routeData: [LocationData] = []
    @State private var isRecording = false
    @State private var isOnRoute = false
    @State private var showMapView = false
    @State private var navToLogView = false
    
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            if !isRecording && !isOnRoute {
                MapView(
                    isRecording: $isRecording,
                    routeData: $routeData
                )
            } else if showMapView {
                MapView(
                    isRecording: $isRecording,
                    routeData: $routeData
                )
                
                RouteDataView(
                    routeData: $routeData
                )
            } else {
                Spacer()
                RouteDataView(
                    routeData: $routeData
                )
                Spacer()
            }
            
            RecordControlView(
                isRecording: $isRecording,
                isOnRoute: $isOnRoute,
                showMapView: $showMapView,
                navToLogView: $navToLogView
            )
        }
        .navigationTitle("Get After It!")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    selectedTab = 0
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // Go to Settings.
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $navToLogView) {
            LogActivityView(
                viewModel: RecordViewModel(apiService: apiService),
                routeData: $routeData
            )
        }
    }
}
