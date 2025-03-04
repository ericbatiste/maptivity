import SwiftUI

struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.activities) { activity in
                    ActivityCardView(activity: activity)
                }
            }
            .padding()
        }
        .onAppear() {
            Task {
                await viewModel.fetchActivities()
            }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.error ?? "Could not load activities.")
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

struct ActivityCardView: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(activity.displayStartTime) on \(activity.displayDate)")
                .font(.headline)
            Text(activity.title)
                .font(.largeTitle)
            Text(activity.designation)
                .font(.subheadline)
            Text("Total time: \(activity.displayDuration)")
                .font(.caption)
            Text("Total distance: \(activity.formattedDistance)")
                .font(.caption)
            Text("Max speed: \(activity.formattedMaxSpeed)")
                .font(.caption)
            Text("Average Speed: \(activity.formattedAverageSpeed)")
                .font(.caption)
            Text("Climbing: \(activity.formattedClimb)")
                .font(.caption)
            Text("Descending: \(activity.formattedDescent)")
                .font(.caption)
            Text("Notes: \(activity.notes)")
                .font(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        }
    }
}

extension Activity {
    var displayDate: String {
        guard let date = Date.fromRubyDateTime(startTime) else {
            return "Invalid date"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
        
    var displayStartTime: String {
        guard let date = Date.fromRubyDateTime(startTime) else {
            return "Invalid time"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var duration: TimeInterval? {
        guard let startDate = Date.fromRubyDateTime(startTime),
              let endDate = Date.fromRubyDateTime(endTime) else {
            return nil
        }
        
        return endDate.timeIntervalSince(startDate)
    }
        
    var displayDuration: String {
        guard let duration = duration else {
            return "Invalid duration"
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "Invalid duration"
    }
    
    var formattedDistance: String {
        let kilometers = distance / 1000
        return String(format: "%.1f km", kilometers)
    }
    
    var formattedMaxSpeed: String {
        let kilometersPerHour = maxSpeed * 3.6
        return String(format: "%.1f km/h", kilometersPerHour)
    }
    
    var formattedAverageSpeed: String {
        let kilometersPerHour = averageSpeed * 3.6
        return String(format: "%.1f km/h", kilometersPerHour)
    }
    
    var formattedClimb: String {
        return String(format: "%.1f m", climbing)
    }
    
    var formattedDescent: String {
        return String(format: "%.1f m", descending)
    }
}
