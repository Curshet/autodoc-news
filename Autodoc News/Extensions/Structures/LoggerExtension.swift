import Foundation
import OSLog

extension Logger {
    
    static let shared = Logger(subsystem: "com.autodoc.news", category: "system")
    
    func print(_ message: String) {
        let date = Date().utf
        info("[\(date)] Logger message -> \(message, privacy: .public)")
    }
    
}
