import SwiftUI
import CoreLocation

struct RecordView: View {
    @StateObject private var viewModel = RecordViewModel()
    
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var encodedRoute: String = ""
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var isRecording = false
    @State private var isOnRoute = false
    @State private var navToLogView = false
    
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            MapView(
                isRecording: $isRecording,
                routeCoordinates: $routeCoordinates
            )
            
            RecordControlView(
                isRecording: $isRecording,
                isOnRoute: $isOnRoute,
                startTime: $startTime,
                endTime: $endTime,
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
                viewModel: viewModel,
                startTime: $startTime,
                endTime: $endTime,
                routeCoordinates: $routeCoordinates,
                encodedRoute: $encodedRoute
            )
        }
    }
}
