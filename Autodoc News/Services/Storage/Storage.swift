import Foundation

class Storage: NSObject, StorageProtocol {
    
    private let fileManager: FileManagerProtocol
    private let queue: DispatchQueue
    
    init(fileManager: FileManagerProtocol) {
        self.fileManager = fileManager
        self.queue = DispatchQueue(label: Bundle.main.identifier + ".dataStorage.concurrent", attributes: .concurrent)
        super.init()
    }
    
}

// MARK: Protocol
extension Storage {
    
    func getFile(from: DataStorageDirectory, name: String) -> Data? {
        guard !name.isEmpty else {
            logger.print(DataStorageMessage.readingName)
            return nil
        }
        
        guard let directory = fileManager.path(target: from) else {
            logger.print(DataStorageMessage.directoryAccess + name)
            return nil
        }
        
        let url = directory.appendingPathComponent(name)
        var data: Data?
        
        queue.sync {
            do {
                data = try Data(contentsOf: url)
            } catch {
                logger.print("\(error)")
            }
        }
        
        return data
    }
    
    func saveFile(to: DataStorageDirectory, name: String, value: Data?) {
        guard !name.isEmpty else {
            logger.print(DataStorageMessage.savingName)
            return
        }
        
        guard let directory = fileManager.path(target: to) else {
            logger.print(DataStorageMessage.directoryAccess + name)
            return
        }
        
        let path: URL?
        
        switch to {
            case .common:
                path = directory
            
            case .catalog(let name):
                path = fileManager.createDirectory(name: name)
        }

        guard let url = path?.appendingPathComponent(name) else {
            logger.print(DataStorageMessage.directoryAccess + name)
            return
        }
        
        queue.async(flags: .barrier) { [weak self] in
            do {
                try value?.write(to: url)
            } catch {
                self?.logger.print("\(error)")
            }
        }
    }
    
    func removeFile(from: DataStorageDirectory, name: String) {
        guard !name.isEmpty else {
            logger.print(DataStorageMessage.removingName)
            return
        }
        
        guard let directory = fileManager.path(target: from) else {
            logger.print(DataStorageMessage.directoryAccess + name)
            return
        }
        
        let url = directory.appendingPathComponent(name)
        
        queue.async(flags: .barrier) { [weak self] in
            do {
                try self?.fileManager.removeItem(atPath: url.path)
            } catch {
                self?.logger.print("\(error)")
            }
        }
    }
    
}

// MARK: - DataStorageMessage
fileprivate enum DataStorageMessage {
    static let readingName = "Data storage reading file error for empty or unavaliable name"
    static let savingName = "Data storage saving file error for empty or unavaliable name"
    static let removingName = "Data storage removing file error for empty or unavaliable name"
    static let directoryAccess = "Data storage directory access error for file: "
}

// MARK: - DataStorageDirectory
enum DataStorageDirectory {
    case common
    case catalog(String)
}
