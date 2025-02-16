import UIKit

class SplashBuilder: Builder, SplashBuilderProtocol {
    
    override init(injector: InjectorProtocol) {
        super.init(injector: injector)
        register()
    }
    
}

// MARK: Private
private extension SplashBuilder {
    
    func register() {
        let coordinator = SplashCoordinator(builder: self)
        injector.register(coordinator, in: .splash)
    }
    
}

// MARK: Protocol
extension SplashBuilder {
    
    var coordinator: SplashCoordinatorProtocol? {
        guard let coordinator = injector.resolve(SplashCoordinator.self, from: .splash) else {
            return error(of: SplashCoordinator.self)
        }
        
        return coordinator
    }
    
    var window: UIWindow? {
        guard let window = injector.resolve(UIWindow.self, from: .application) else {
            return error(of: UIWindow.self)
        }
        
        return window
    }
    
    var viewController: SplashViewController? {
        guard let coordinator = injector.resolve(SplashCoordinator.self, from: .splash) else {
            return error(of: SplashCoordinator.self)
        }
        
        let viewModel = SplashViewModel(coordinator: coordinator)
        let imageView = UIImageView()
        let view = SplashView(imageView: imageView)
        let viewController = SplashViewController(viewModel: viewModel, view: view)
        return viewController
    }
    
}
