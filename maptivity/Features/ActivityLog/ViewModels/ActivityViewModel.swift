import SwiftUI

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var error: String? = nil
    @Published var activities: [Activity] = []
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchActivities() async {
        isLoading = true
        
        do {
            let fetchedActivities: [Activity] = try await apiService.request(
                endpoint: "activities",
                requiresAuth: true
            )
            
            activities = fetchedActivities
        } catch {
            self.error = error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }
}
