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
            
            HStack {
                Spacer()
                Button {
                    showMapView.toggle()
                } label: {
                    Image(systemName: "mappin.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(.systemGray))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .padding(.trailing)
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
