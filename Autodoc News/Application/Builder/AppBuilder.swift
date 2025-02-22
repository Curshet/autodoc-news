import UIKit
import OSLog

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
        injector.register(userDefaults, in: .application)
        injector.register(URLSession.shared, in: .application)
        injector.register(keyWindow, in: .application)
    }
    
    var keyWindow: UIWindow {
        let window = UIWindow()
        window.makeKeyAndVisible()
        return window
    }
    
    var userDefaults: UserDefaultsProtocol {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        return userDefaults
    }
    
}

// MARK: Protocol
extension AppBuilder {
    
    var appCoordinator: AppCoordinatorProtocol? {
        AppCoordinator(builder: self)
    }
    
    var splashCoordinator: SplashCoordinatorProtocol? {
        let builder = SplashBuilder(injector: injector)
        return builder.coordinator
    }
    
    var navigationCoordinator: NavigationCoordinatorProtocol? {
        let builder = NavigationBuilder(injector: injector)
        return builder.coordinator
    }
    
}
