import Foundation

struct Activity: Codable, Identifiable {
    let id: Int
    let designation: String
    let notes: String
    let startTime: String
    let endTime: String
    let route: String
    let distance: Float
}

struct NewActivity: Codable {
    let title: String
    let designation: String
    let notes: String
    let startTime: String
    let endTime: String
    let route: String
    let distance: Float
}
