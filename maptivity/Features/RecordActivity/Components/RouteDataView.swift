import SwiftUI

struct RouteDataView: View {
    @Binding var routeData: [LocationData]
    @Binding var isRecording: Bool
    @Binding var isOnRoute: Bool
    @Binding var showMapView: Bool
    
    var body: some View {
        if !isRecording && isOnRoute && !showMapView {
            VStack {
                HStack {
                    DataElementView(key: "Time", value: timer, paused: true)
                    Divider()
                    DataElementView(key: "Distance", value: formattedDistance, paused: true)
                }
                Divider()
                HStack {
                    DataElementView(key: "Speed", value: formattedSpeed, paused: true)
                    Divider()
                    DataElementView(key: "Altitude", value: formattedAltitude, paused: true)
                }
            }
            .padding()
        } else {
            VStack(spacing: 0) {
                DataElementView(key: "Time", value: timer)
                Divider()
                DataElementView(key: "Distance", value: formattedDistance)
                Divider()
                DataElementView(key: "Speed", value: formattedSpeed)
                Divider()
                DataElementView(key: "Altitude", value: formattedAltitude)
            }
            .padding()
        }
    }
    
    private var activeData: LocationData? {
        return routeData.last
    }
    
    private var formattedDistance: String {
        guard var distance = activeData?.distance else { return "0.0" }
        distance /= 1000
        return String(format: "%.1f km", distance)
    }
    
    private var formattedSpeed: String {
        guard var speed = activeData?.speed else { return "0.0" }
        speed *= 3.6
        return String(format: "%.1f km/h", speed)
    }
    
    private var formattedAltitude: String {
        guard let altitude = activeData?.altitude else { return "0.0" }
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

struct DataElementView: View {
    let key: String
    let value: String
    var paused: Bool = false
    
    var smText: CGFloat {
        paused ? 14 : 24
    }
    
    var lgText: CGFloat {
        paused ? 30 : 80
    }
    
    var body: some View {
        VStack {
            Text("\(key):")
                .font(.system(size: smText))
                .padding(.top, 8)
            Text(value)
                .font(.system(size: lgText))
                .padding(.bottom)
        }
        .frame(maxWidth: .infinity)
    }
}
