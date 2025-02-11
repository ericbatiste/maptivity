import SwiftUI

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var error: APIError?
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var activities: [Activity] = []
    
    func fetchActivities() {
        isLoading = true
        
        Task {
            do {
                let fetchedActivities = try await APIRequests.shared.fetchActivities()
                
                activities = fetchedActivities
                error = nil
            } catch let error as APIError {
                self.error = error
                showAlert = true
            } catch {
                self.error = .networkError(error)
                showAlert = true
            }
            isLoading = false
        }
    }
}
