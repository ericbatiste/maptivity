import SwiftUI
import MapboxMaps

struct RecordControlView: View {
    @Binding var isRecording: Bool
    @Binding var isOnRoute: Bool
    @Binding var showMapView: Bool
    @Binding var navToLogView: Bool
    
    var body: some View {
        ZStack {
            VStack {
                if isRecording && isOnRoute {
                    CircleButton(
                        systemName: "pause.fill",
                        backgroundColor: Color(red: 0.952, green: 0.572, blue: 0.188)
                    ) {
                        isRecording = false
                        isOnRoute = true
                    }
                    
                } else if !isRecording && isOnRoute {
                    HStack {
                        CircleButton(
                            systemName: "circle.fill",
                            backgroundColor: Color(red: 0.270, green: 0.811, blue: 0.819)
                        ) {
                            isRecording = true
                            isOnRoute = true
                        }
                        
                        CircleButton(
                            systemName: "stop.fill",
                            backgroundColor: Color(red: 0.898, green: 0.176, blue: 0.050)
                        ) {
                            navToLogView = true
                        }
                    }
                    
                } else if !isRecording && !isOnRoute {
                    CircleButton(
                        systemName: "circle.fill",
                        backgroundColor: Color(red: 0.2703, green: 0.811, blue: 0.819)
                    ) {
                        isRecording = true
                        isOnRoute = true
                    }
                }
            }
            
            HStack {
                Spacer()
                if isRecording || isOnRoute {
                    Button {
                        showMapView.toggle()
                    } label: {
                        Image(systemName: showMapView ? "mappin.circle.fill" : "mappin.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: 40, height: 40)
                        
                    }
                    .padding(.trailing)
                }
            }
        }
        .background(Color(.systemGray6))
    }
}

struct CircleButton: View {
    let systemName: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .foregroundColor(.primary)
                .padding(18)
                .frame(width: 68, height: 68)
                .background(backgroundColor)
                .cornerRadius(10)
        }
        .padding()
    }
}
