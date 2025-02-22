import Foundation

final class Injector: InjectorProtocol {

    private var containers: [InjectorKey : InjectorContainer]
    private let queue: DispatchQueue
    
    init() {
        self.containers = [InjectorKey : InjectorContainer]()
        self.queue = DispatchQueue(label: Bundle.main.identifier + ".injector.concurrent", attributes: .concurrent)
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
            containers[container]?.value["\(type)"] as? T
        }
    }
    
    func remove(container: InjectorKey) {
        guard container != .application else { return }
        containers[container] = nil
    }
    
}

// MARK: - InjectorContainer
fileprivate class InjectorContainer {
    var value = [String : Any]()
}

// MARK: - InjectorKey
enum InjectorKey: Hashable {
    case application
    case splash
    case navigation
}
