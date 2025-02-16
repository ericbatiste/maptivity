import Foundation
import CoreLocation

extension Array where Element == LocationData {
    func encodedPolyline() -> String {
        
        let coordinates = map(\.coordinate)
        
        var lastLat = 0
        var lastLng = 0
        var result = ""
        
        for coordinate in coordinates {
            let lat = Int(round(coordinate.latitude * 1e5))
            let lng = Int(round(coordinate.longitude * 1e5))
            
            let deltaLat = lat - lastLat
            lastLat = lat
            result += encode(coordinate: deltaLat)
            
            let deltaLng = lng - lastLng
            lastLng = lng
            result += encode(coordinate: deltaLng)
        }
        
        return result
    }
    
    private func encode(coordinate: Int) -> String {
        var coord = coordinate
        coord = coord < 0 ? ~(coord << 1) : (coord << 1)
        var result = ""
        
        while coord >= 0x20 {
            let chunk = String(UnicodeScalar((0x20 | (coord & 0x1f)) + 63)!)
            result += chunk
            coord >>= 5
        }
        
        result += String(UnicodeScalar(coord + 63)!)
        return result
    }
    
    static func decodePolyline(_ polyline: String) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        var idx = 0
        var lat = 0
        var lng = 0
        
        while idx < polyline.count {
            var result = 1
            var shift = 0
            var b: Int
            
            repeat {
                b = Int(polyline[polyline.index(polyline.startIndex, offsetBy: idx)].asciiValue ?? 0) - 63
                idx += 1
                result += (b & 0x1f) << shift
                shift += 5
            } while b >= 0x20
            
            lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
            
            result = 1
            shift = 0
            
            repeat {
                b = Int(polyline[polyline.index(polyline.startIndex, offsetBy: idx)].asciiValue ?? 0) - 63
                idx += 1
                result += (b & 0x1f) << shift
                shift += 5
            } while b >= 0x20
            
            lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1)
            
            coordinates.append(CLLocationCoordinate2D(
                latitude: Double(lat) / 1e5,
                longitude: Double(lng) / 1e5
            ))
        }
        
        return coordinates
    }
}

