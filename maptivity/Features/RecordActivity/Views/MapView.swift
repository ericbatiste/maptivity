import SwiftUI
import MapboxMaps
import CoreLocation
import Combine

struct MapView: View {
    @State private var viewport: Viewport = .followPuck(zoom: 16, bearing: .constant(0))
    @State private var cancellables = Set<AnyCancellable>()
    @State private var accumulatedDistance: CLLocationDistance = 0
    
    @Binding var isRecording: Bool
    @Binding var routeData: [LocationData]
    
    var body: some View {
        VStack {
            MapReader { proxy in
                Map(viewport: $viewport) {
                    Puck2D(bearing: .heading)
                    PolylineAnnotationGroup {
                        PolylineAnnotation(lineCoordinates: routeData.map { $0.coordinate })
                            .lineColor(.blue)
                            .lineWidth(5)
                            .lineOpacity(0.8)
                    }
                }
                .mapStyle(.outdoors)
                .overlay(alignment: .bottomTrailing) {
                    LocateButtonView(viewport: $viewport)
                }
                .onAppear {
                    observeLocationChanges(proxy: proxy)
                }
            }
        }
    }
    
    private func observeLocationChanges(proxy: MapProxy) {
        proxy.location?.onLocationChange.observe { locations in
            guard isRecording, let newLocation = locations.last else { return }
            
            let prevCoordinate = routeData.last?.coordinate
            
            if let lastCoordinate = prevCoordinate {
                let incrementalDistance = newLocation.coordinate.distance(to: lastCoordinate)
                accumulatedDistance += incrementalDistance
            }
            
            routeData.append(LocationData(
                coordinate: newLocation.coordinate,
                speed: newLocation.speed ?? 0,
                distance: accumulatedDistance,
                altitude: newLocation.altitude ?? 0,
                timestamp: newLocation.timestamp
            ))
        }
        .store(in: &cancellables)
    }
}
