import SwiftUI

struct RecordControls: View {
    @Binding var isRecording: Bool
    @Binding var isOnRoute: Bool
    @Binding var selectedActivity: String
    
    var body: some View {
        VStack {
            Picker("Hike", selection: $selectedActivity) {
                Text("Hike").tag("Hike")
                Text("Run").tag("Run")
                Text("Mountain Bike").tag("Mountain Bike")
                Text("Alpine Ski").tag("Alpine Ski")
                Text("Backcountry Ski").tag("Backcountry Ski")
            }
            .pickerStyle(MenuPickerStyle())
            VStack {
                if isRecording && isOnRoute {
                    Button {
                        isRecording = false
                        isOnRoute = true
                    } label: {
                        Image(systemName: "pause.circle")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .padding()
                    
                } else if !isRecording && isOnRoute {
                    HStack {
                        Button {
                            isRecording = true
                            isOnRoute = true
                        } label: {
                            Image(systemName: "record.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .padding()

                        Button {
                            isRecording = false
                            isOnRoute = false
                        } label: {
                            Image(systemName: "stop.circle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    
                } else if !isRecording && !isOnRoute {
                    Button {
                        isRecording = true
                        isOnRoute = true
                    } label: {
                        Image(systemName: "record.circle")
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
        }
    }
}

