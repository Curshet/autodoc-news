import Foundation

extension NSError {
    
    static var system: NSError {
        Self(domain: Bundle.main.identifier, code: 766, userInfo: [NSLocalizedDescriptionKey : "Системная ошибка"])
    }
    
}
