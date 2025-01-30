import SwiftUI

struct RecordView: View {
    @State private var isRecording = false
    @State private var isOnRoute = false
    @State private var selectedActivity = "Hike"
    @Binding var selectedTab: Int

    var body: some View {
        VStack {
            HStack {
                Button("Exit") {
                    selectedTab = 0
                }
                
                Spacer()
                
                Text("\(selectedActivity)")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    // action
                } label: {
                    Image(systemName: "gearshape.fill")
                }
            }
            .padding()
            
            MapView(isRecording: $isRecording)
            
            RecordControls(
                isRecording: $isRecording,
                isOnRoute: $isOnRoute,
                selectedActivity: $selectedActivity
            )
        }
    }
}
