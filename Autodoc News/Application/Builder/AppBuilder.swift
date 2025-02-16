import UIKit

final class AppBuilder: Builder, AppBuilderProtocol {
    
    override init(injector: InjectorProtocol) {
        super.init(injector: injector)
        register()
    }
    
}

// MARK: Private
private extension AppBuilder {
    
    func register() {
        injector.register(FileManager.default, in: .application)
        injector.register(keyWindow, in: .application)
    }
    
    var keyWindow: UIWindow {
        let viewController = ViewController()
        let window = UIWindow()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        return window
    }
    
}

// MARK: Protocol
extension AppBuilder {
    
    var coordinator: AppCoordinatorProtocol? {
        AppCoordinator(builder: self)
    }
    
}
