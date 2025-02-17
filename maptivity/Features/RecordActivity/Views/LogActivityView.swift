import SwiftUI
import CoreLocation

struct LogActivityView: View {
    @ObservedObject var viewModel: RecordViewModel
    
    @State private var title: String = ""
    @State private var designation: String = "Hike"
    @State private var notes: String = ""
    @State private var showingSubmitAlert: Bool = false
    
    @Binding var routeData: [LocationData]
    
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
            Section {
                VStack(spacing: 20) {
                    
                    // Title Form Element...
                    TextField("Give your activity a title...", text: $title)
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .tint(.blue)
                    
                    // Picker Form Element...
                    Menu {
                        Picker("Activity", selection: $designation) {
                            ForEach(activities, id: \.self) { activity in
                                Text(activity)
                                    .tag(activity)
                            }
                        }
                    } label: {
                        HStack {
                            Text(designation)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.blue), lineWidth: 1)
                        )
                    }
                    
                    // Notes Form Element...
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $notes)
                            .frame(minHeight: 120)
                        
                        if notes.isEmpty {
                            Text("Anything to note about this adventure?")
                                .foregroundColor(Color(.systemGray3))
                                .padding(8)
                                .allowsHitTesting(false)
                        }
                    }
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.blue), lineWidth: 1)
                    )
                }
                .padding(.vertical, 20)
            }
        
            Section {
                Button(action: submitActivity) {
                    HStack {
                        Spacer()
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .padding(.trailing, 8)
                        } else {
                            Text("Submit Activity")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(title.isEmpty ? Color(.systemGray3) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(title.isEmpty || viewModel.isLoading)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Log Activity")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.error == nil ? "Success" : "Error"),
                message: Text(viewModel.error?.localizedDescription ?? "Activity submitted successfully!"),
                dismissButton: .default(Text("OK")) {
                    if viewModel.error == nil {
                        routeData = []
                        title = ""
                        notes = ""
                    }
                    viewModel.error = nil
                }
            )
        }
    }
    
    private func submitActivity() {
        guard !routeData.isEmpty else { return }
        
        let formattedStartTime = routeData.first!.timestamp.toRubyDateTime
        let formattedEndTime = routeData.last!.timestamp.toRubyDateTime
        let encodedRoute = routeData.encodedPolyline()
        let totalDistance = routeData.last!.distance
        let maxSpeed = routeData.maxSpeed()
        let averageSpeed = routeData.averageSpeed()
        let climbing = routeData.totalClimb()
        let descending = routeData.totalDescent()
        
        viewModel.createActivity(
            title: title,
            designation: designation,
            notes: notes,
            startTime: formattedStartTime,
            endTime: formattedEndTime,
            route: encodedRoute,
            distance: totalDistance,
            maxSpeed: maxSpeed,
            averageSpeed: averageSpeed,
            climbing: climbing,
            descending: descending
        )
    }
}
