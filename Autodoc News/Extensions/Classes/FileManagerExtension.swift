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
            logger.print(FileManagerMessage.directoryName)
            return nil
        }
        
        guard let url = path(target: .catalog(name)) else {
            logger.print(FileManagerMessage.directoryPath)
            return nil
        }
        
        guard !fileExists(atPath: url.path) else { return url }
        
        do {
            try createDirectory(atPath: url.path, withIntermediateDirectories: true)
            return url
        } catch {
            logger.print(FileManagerMessage.directoryCreating + "\(error)")
            return nil
        }
    }
    
}

// MARK: - FileManagerMessage
fileprivate enum FileManagerMessage {
    static let directoryName = "File manager directory creating error for empty or unavaliable name"
    static let directoryPath = "File manager directory creating error for unavaliable URL"
    static let directoryCreating = "File manager directory creating error: "
}
