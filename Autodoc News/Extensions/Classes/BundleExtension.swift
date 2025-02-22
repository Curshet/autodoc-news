import Foundation

extension Bundle {
    
    var identifier: String {
        object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? "com.autodoc.identifier"
    }
    
}
