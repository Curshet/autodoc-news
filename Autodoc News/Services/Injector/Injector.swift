import Foundation

final class Injector: InjectorProtocol {

    private var containers: [InjectorKey : InjectorContainer]
    private let queue: DispatchQueue
    
    init() {
        self.containers = [InjectorKey : InjectorContainer]()
        self.queue = DispatchQueue(label: "com.autodoc.news.injector.concurrent", attributes: .concurrent)
    }
    
    func register<T>(_ object: T, in container: InjectorKey) {
        var value: InjectorContainer? {
            containers[container]
        }

        if value == nil {
            containers[container] = InjectorContainer()
        }
        
        queue.async(flags: .barrier) { [weak self] in
            self?.containers[container]?.value["\(T.self)"] = object
        }
    }
    
    func resolve<T>(_ type: T.Type, from container: InjectorKey) -> T? {
        queue.sync {
            containers[container] as? T
        }
    }
    
}

// MARK: - InjectorKey
enum InjectorKey: Hashable {
    case application
    case presentation
}

// MARK: - InjectorContainer
final class InjectorContainer {
    var value = [String : Any]()
}
