import SwiftUI
import MapboxMaps

struct RecordView: View {
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
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
            
            RecordControls(
                isRecording: $isRecording,
                isOnRoute: $isOnRoute,
                routeCoordinates: $routeCoordinates,
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
            LogActivityView()
        }
    }
}
