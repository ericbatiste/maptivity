import Foundation

struct JWTParser {
    static func decode(_ token: String) -> [String: Any]? {
        let segments = token.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        return decodePayload(segments[1])
    }
    
    static func getExpirationDate(from token: String) -> Date? {
        guard let payload = decode(token),
              let exp = payload["exp"] as? TimeInterval else {
            return nil
        }
        
        return Date(timeIntervalSince1970: exp)
    }
    
    private static func decodePayload(_ payload: String) -> [String: Any]? {
        var base64String = payload
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64String.count % 4 != 0 {
            base64String += "="
        }
        
        guard let data = Data(base64Encoded: base64String) else { return nil }
        
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("Failed to decode payload: \(error)")
            return nil
        }
    }
}

