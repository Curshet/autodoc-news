import Foundation

extension NSObject: LoggerProtocol {
    
    static var typeName: String {
        description()
    }
    
}
