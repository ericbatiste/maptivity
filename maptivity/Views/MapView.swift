import SwiftUI
import MapboxMaps
import CoreLocation
import Combine

struct MapView: View {
    @State private var viewport: Viewport = .followPuck(zoom: 16, bearing: .constant(0))
    @State private var cancellables = Set<AnyCancellable>()
    @Binding var isRecording: Bool
    @Binding var routeCoordinates: Array<CLLocationCoordinate2D>
    
    var body: some View {
        VStack {
            MapReader { proxy in
                Map(viewport: $viewport) {
                    Puck2D(bearing: .heading)
                    PolylineAnnotationGroup {
                        PolylineAnnotation(lineCoordinates: routeCoordinates)
                            .lineColor(.blue)
                            .lineWidth(5)
                            .lineOpacity(0.8)
                    }
                }
                .mapStyle(.outdoors)
                .overlay(alignment: .bottomTrailing) {
                    LocateButton(viewport: $viewport)
                }
                .onAppear {
                    observeLocationChanges(proxy: proxy)
                }
            }
        }
    }
    
    private func observeLocationChanges(proxy: MapProxy) {
        proxy.location?.onLocationChange.observe { locations in
            if isRecording, let newLocation = locations.last?.coordinate {
                routeCoordinates.append(newLocation)
//              print(routeCoordinates)
            }
        }
        .store(in: &cancellables)
    }
}
