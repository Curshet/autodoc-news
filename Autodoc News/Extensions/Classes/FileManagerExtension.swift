import Foundation

extension FileManager: FileManagerProtocol {
    
    func path(target: DataStorageDirectory) -> URL? {
        let url = urls(for: .documentDirectory, in: .userDomainMask).first

        switch target {
            case .common:
                return url
            
            case .catalog(let name):
                guard !name.isEmpty else { return url }
                return url?.appendingPathComponent(name)
        }
        
    }
    
    @discardableResult func createDirectory(name: String) -> URL? {
        guard !name.isEmpty else {
            logger.print("File manager directory creating error for empty or unavaliable name")
            return nil
        }
        
        guard let url = path(target: .catalog(name)) else {
            logger.print("File manager directory creating error for unavaliable URL")
            return nil
        }
        
        guard !fileExists(atPath: url.path) else { return url }
        
        do {
            try createDirectory(atPath: url.path, withIntermediateDirectories: true)
            return url
        } catch {
            logger.print("File manager directory creating error: \(error)")
            return nil
        }
    }
    
}
