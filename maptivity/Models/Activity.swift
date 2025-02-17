import Foundation
import CoreLocation

struct Activity: Codable, Identifiable {
    let id: Int
    let title: String
    let designation: String
    let notes: String
    let startTime: String
    let endTime: String
    let route: String
    let distance: Double
    let maxSpeed: Double
    let averageSpeed: Double
    let climbing: Double
    let descending: Double
    
}

struct NewActivity: Codable {
    let title: String
    let designation: String
    let notes: String
    let startTime: String
    let endTime: String
    let route: String
    let distance: Double
    let maxSpeed: Double
    let averageSpeed: Double
    let climbing: Double
    let descending: Double
}

struct LocationData {
    var coordinate: CLLocationCoordinate2D
    var speed: CLLocationSpeed
    var distance: CLLocationDistance
    var altitude: CLLocationDistance
    var timestamp: Date
}
