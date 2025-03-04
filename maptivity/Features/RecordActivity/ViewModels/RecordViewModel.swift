import SwiftUI

@MainActor
class RecordViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    @Published var error: String? = nil
    
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func createActivity(
        title: String,
        designation: String,
        notes: String,
        startTime: String,
        endTime: String,
        route: String,
        distance: Double,
        maxSpeed: Double,
        averageSpeed: Double,
        climbing: Double,
        descending: Double
    ) async {
        isLoading = true
    
        do {
            let newActivity = NewActivity(
                title: title,
                designation: designation,
                notes: notes,
                startTime: startTime,
                endTime: endTime,
                route: route,
                distance: distance,
                maxSpeed: maxSpeed,
                averageSpeed: averageSpeed,
                climbing: climbing,
                descending: descending
            )
            
            let _: Activity = try await apiService.request(
                endpoint: "activities",
                method: "POST",
                body: newActivity,
                requiresAuth: true
            )
            
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
        showAlert = true
    }
}
