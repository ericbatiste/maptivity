import SwiftUI

struct LogActivityView: View {
    @State private var title: String = ""
    @State private var designation: String = "Hike"
    @State private var notes: String = ""
    @State private var showingSubmitAlert: Bool = false
    
    let activities = [
        "Walk",
        "Hike",
        "Run",
        "Trail Run",
        "Mountain Bike",
        "Alpine Ski",
        "Backcountry Ski"
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
                Button(action: submitActivity) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .navigationTitle("Log Activity")
        .alert("Success", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Activity submitted successfully!")
        }
    }
    
    private func submitActivity() {
        // POST to backend
        
        showingSubmitAlert = true
        
        title = ""
        notes = ""
    }
}
