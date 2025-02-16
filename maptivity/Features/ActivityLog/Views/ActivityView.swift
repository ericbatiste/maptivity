import SwiftUI

struct ActivityView: View {
    @StateObject private var viewModel = ActivityViewModel()
    
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
            viewModel.fetchActivities()
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK") {}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "Could not load activities.")
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

struct ActivityCardView: View {
    var activity: Activity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(activity.title)
                .font(.headline)
            Text(activity.designation)
                .font(.subheadline)
            Text(activity.notes)
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
