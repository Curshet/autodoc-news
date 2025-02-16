import Foundation

protocol StorageProtocol {
    func getFile(from: DataStorageDirectory, name: String) -> Data?
    func saveFile(to: DataStorageDirectory, name: String, value: Data?)
    func removeFile(from: DataStorageDirectory, name: String)
}
