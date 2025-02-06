import SwiftUI
import MapboxMaps

struct RecordView: View {
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var isRecording = false
    @State private var isOnRoute = false
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            HStack {
                Button("Exit") {
                    selectedTab = 0
                }
                
                Spacer()
                
                Button {
                    // action
                } label: {
                    Image(systemName: "gearshape.fill")
                }
            }
            .padding()
            
            MapView(
                isRecording: $isRecording,
                routeCoordinates: $routeCoordinates
            )
            
            RecordControls(
                isRecording: $isRecording,
                isOnRoute: $isOnRoute,
                routeCoordinates: $routeCoordinates
            )
        }
    }
}
