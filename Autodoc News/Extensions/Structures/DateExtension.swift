import Foundation

extension Date {
    
    static func convert(from string: String) -> String {
        guard !string.isEmpty else { return string }
        let info = string.components(separatedBy: "T").first ?? string
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let raw = formatter.date(from: info) else { return string }
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: raw)
    }
    
    var utf: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
}
