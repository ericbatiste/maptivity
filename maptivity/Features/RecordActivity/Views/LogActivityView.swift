import SwiftUI
import CoreLocation

struct LogActivityView: View {
    @ObservedObject var viewModel: RecordViewModel
    
    @State private var title: String = ""
    @State private var designation: String = "Hike"
    @State private var notes: String = ""
    @State private var distance: Float = 0.0
    @State private var showingSubmitAlert: Bool = false
    
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var routeCoordinates: Array<CLLocationCoordinate2D>
    @Binding var encodedRoute: String
    
    let activities = [
        "Walk",
        "Hike",
        "Run",
        "Trail Run",
        "Bike Ride",
        "Mountain Bike Ride",
        "Alpine Skiing",
        "Backcountry Skiing"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Activity Details")) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Picker("Activity", selection: $designation) {
                    ForEach(activities, id: \.self) { activity in
                        Text(activity)
                    }
                }
                
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
            }
            
            Section {
                Button {
                    submitActivity()
                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(title.isEmpty || viewModel.isLoading)
            }
        }
        .navigationTitle("Log Activity")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.error == nil ? "Success" : "Error"),
                message: Text(viewModel.error?.localizedDescription ?? "Activity submitted successfully!"),
                dismissButton: .default(Text("OK")) {
                    if viewModel.error == nil {
                        routeCoordinates = []
                        title = ""
                        notes = ""
                    }
                    viewModel.error = nil
                }
            )
        }
    }
    
    private func submitActivity() {
        let formattedStartTime = startTime.rubyDateTime
        let formattedEndTime = endTime.rubyDateTime
        encodedRoute = routeCoordinates.encodedPolyline()
        
        viewModel.createActivity(
            title: title,
            designation: designation,
            notes: notes,
            startTime: formattedStartTime,
            endTime: formattedEndTime,
            route: encodedRoute,
            distance: distance
        )
    }
}
