import SwiftUI

@MainActor
class RecordViewModel: ObservableObject {
    @Published var error: APIError?
    @Published var isLoading: Bool = false
    @Published var showAlert = false
    
    func createActivity(
        title: String,
        designation: String,
        notes: String,
        startTime: String,
        endTime: String,
        route: String,
        distance: Double
    ) {
        isLoading = true
        
        Task {
            do {
                let newActivity = NewActivity(
                    title: title,
                    designation: designation,
                    notes: notes,
                    startTime: startTime,
                    endTime: endTime,
                    route: route,
                    distance: distance
                )
                
                _ = try await APIRequests.shared.createActivity(newActivity)
                
                error = nil
            } catch let error as APIError {
                self.error = error
            } catch {
                self.error = .networkError(error)
            }
            isLoading = false
            showAlert = true
        }
    }
}
