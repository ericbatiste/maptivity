import SwiftUI
import MapboxMaps

struct RecordControls: View {
    @State private var encodedRoute: String = ""
    @Binding var isRecording: Bool
    @Binding var isOnRoute: Bool
    @Binding var routeCoordinates: Array<CLLocationCoordinate2D>
    @Binding var navToLogView: Bool
    
    var body: some View {
        VStack {
            if isRecording && isOnRoute {
                CircleButton(systemName: "pause.circle") {
                    isRecording = false
                    isOnRoute = true
                }
                
            } else if !isRecording && isOnRoute {
                HStack {
                    CircleButton(systemName: "record.circle") {
                        isRecording = true
                        isOnRoute = true
                    }
                    
                    CircleButton(systemName: "stop.circle") {
                        isRecording = false
                        isOnRoute = false
                        // encodedRoute = routeCoordinates.encodedPolyline()
                        navToLogView = true
                    }
                }
                
            } else if !isRecording && !isOnRoute {
                CircleButton(systemName: "record.circle") {
                    isRecording = true
                    isOnRoute = true
                }
            }
        }
    }
}

struct CircleButton: View {
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.blue)
                .clipShape(Circle())
        }
        .padding()
    }
}
