import Foundation
import Combine

final class AppCoordinator: NSObject, AppCoordinatorProtocol {
    
    private let builder: AppBuilderProtocol
    private var coordinators: [AppCoordinatorKey : Any]
    private var subscriptions: Set<AnyCancellable>
    
    init(builder: AppBuilderProtocol) {
        self.builder = builder
        self.coordinators = [AppCoordinatorKey : Any]()
        self.subscriptions = Set<AnyCancellable>()
        super.init()
    }
    
    func start() -> Bool {
        logger.print("Application successfully starts")
        startSplashModule()
        return true
    }
    
}

// MARK: Private
private extension AppCoordinator {
    
    func startSplashModule() {
        guard let coordinator = builder.splashCoordinator else {
            logger.print("Application doesn't have a splash coordinator")
            return
        }
        
        coordinator.exitEvent.sink { [weak self] in
            self?.startNavigationModule()
        }.store(in: &subscriptions)

        coordinators[.splash] = coordinator
        coordinator.startEvent.send()
    }
    
    func startNavigationModule() {
        guard let coordinator = builder.navigationCoordinator else {
            logger.print("Application doesn't have a navigation coordinator")
            return
        }

        coordinators.removeAll()
        coordinators[.navigation] = coordinator
        coordinator.start()
    }
    
}

// MARK: - AppCoordinatorKey
fileprivate enum AppCoordinatorKey: Hashable {
    case splash
    case navigation
}
