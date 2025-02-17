import SwiftUI

struct RouteDataView: View {
    @Binding var routeData: [LocationData]
    
    var body: some View {
        VStack {
            Text("Time: \(timer)")
                .padding(.bottom, 10)
            Text("Distace: \(formattedDistance)")
                .padding(.bottom, 10)
            Text("Speed: \(formattedSpeed)")
                .padding(.bottom, 10)
            Text("Altitude: \(formattedAltitude)")
        }
        .padding()
        .font(.system(size: 20))
    }
    
    private var activeData: LocationData? {
        return routeData.last
    }
    
    private var formattedDistance: String {
        guard var distance = activeData?.distance else { return "N/A" }
        distance /= 1000
        return String(format: "%.1f km", distance)
    }
    
    private var formattedSpeed: String {
        guard var speed = activeData?.speed else { return "N/A" }
        speed *= 3.6
        return String(format: "%.1f km/h", speed)
    }
    
    private var formattedAltitude: String {
        guard let altitude = activeData?.altitude else { return "N/A" }
        return String(format: "%.1f m", altitude)
    }
    
    private var timer: String {
        guard let startTime = routeData.first?.timestamp,
              let currentTime = activeData?.timestamp else {
            return "00:00:00"
        }
        
        let elapsedTime = currentTime.timeIntervalSince(startTime)
        let hours = Int(elapsedTime) / 3600
        let minutes = Int(elapsedTime) / 60 % 60
        let seconds = Int(elapsedTime) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
