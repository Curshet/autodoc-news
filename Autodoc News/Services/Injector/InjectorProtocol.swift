import Foundation

protocol InjectorProtocol {
    func register<T>(_ object: T, in container: InjectorKey)
    func resolve<T>(_ type: T.Type, from container: InjectorKey) -> T?
}
