import Foundation
import Combine

class SplashCoordinator: NSObject, SplashCoordinatorProtocol, SplashCoordinatorExitProtocol {
    
    let startEvent: PassthroughSubject<Void, Never>
    let exitEvent: AnyPublisher<Void, Never>
    
    private let builder: SplashBuilderProtocol
    private let exitPublisher: PassthroughSubject<Void, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(builder: SplashBuilderProtocol) {
        self.builder = builder
        self.startEvent = PassthroughSubject<Void, Never>()
        self.exitPublisher = PassthroughSubject<Void, Never>()
        self.exitEvent = AnyPublisher(exitPublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init()
        setupObservers()
    }
    
    func exit() {
        exitPublisher.send()
    }
    
}

// MARK: Private
private extension SplashCoordinator {
    
    func setupObservers() {
        startEvent.sink { [weak self] in
            self?.start()
        }.store(in: &subscriptions)
    }
    
    func start() {
        guard let window = builder.window, let viewController = builder.viewController else {
            logger.print("Application doesn't have necessary objects for splash")
            return
        }
        
        window.rootViewController = viewController
        logger.print("Application showing a splash screen")
    }
    
}
