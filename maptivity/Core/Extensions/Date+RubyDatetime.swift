import Foundation

extension Date {
    private static let rubyDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    var rubyDateTime: String {
        return Date.rubyDateFormatter.string(from: self)
    }
    
    static func fromRubyDateTime(_ rubyString: String) -> Date? {
        return rubyDateFormatter.date(from: rubyString)
    }
}
