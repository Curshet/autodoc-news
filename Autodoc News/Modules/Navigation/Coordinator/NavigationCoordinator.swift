import Foundation

class NavigationCoordinator: NSObject, NavigationCoordinatorProtocol, NavigationCoordinatorRouteProtocol {
    
    private let builder: NavigationBuilderProtocol
    
    init(builder: NavigationBuilderProtocol) {
        self.builder = builder
        super.init()
    }
    
    func start() {
        guard let window = builder.window, let viewController = builder.viewController else {
            logger.print("Application doesn't have necessary objects for navigation menu")
            return
        }
        
        window.rootViewController = viewController
        logger.print("Application showing a navigation menu screen")
    }
    
    func route() {}
    
}
