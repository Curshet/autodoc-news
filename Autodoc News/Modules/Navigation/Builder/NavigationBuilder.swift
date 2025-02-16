import UIKit

class NavigationBuilder: Builder, NavigationBuilderProtocol {
    
    override init(injector: InjectorProtocol) {
        super.init(injector: injector)
        injector.remove(container: .splash)
        register()
    }
    
}

// MARK: Private
private extension NavigationBuilder {
    
    func register() {
        let coordinator = NavigationCoordinator(builder: self)
        injector.register(coordinator, in: .navigation)
    }
    
}

// MARK: Protocol
extension NavigationBuilder {
    
    var coordinator: NavigationCoordinatorProtocol? {
        guard let coordinator = injector.resolve(NavigationCoordinator.self, from: .navigation) else {
            return error(of: NavigationCoordinator.self)
        }
        
        return coordinator
    }
    
    var window: UIWindow? {
        guard let window = injector.resolve(UIWindow.self, from: .application) else {
            return error(of: UIWindow.self)
        }
        
        return window
    }
    
    var viewController: NavigationViewController? {
        guard let coordinator = injector.resolve(NavigationCoordinator.self, from: .navigation) else {
            return error(of: NavigationCoordinator.self)
        }
        
        let viewModel = NavigationViewModel(coorinator: coordinator)
        let view = NavigationView()
        let viewController = NavigationViewController(viewModel: viewModel, customView: view)
        return viewController
    }
    
}
