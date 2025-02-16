import Foundation
import Combine

class SplashViewModel: SplashViewModelProtocol {
    
    let intenalEvent: PassthroughSubject<SplashViewModelInternal, Never>
    let externalEvent: AnyPublisher<SplashViewData, Never>
    
    private weak var coordinator: SplashCoordinatorExitProtocol?
    private let externalPublisher: PassthroughSubject<SplashViewData, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(coordinator: SplashCoordinatorExitProtocol) {
        self.coordinator = coordinator
        self.intenalEvent = PassthroughSubject<SplashViewModelInternal, Never>()
        self.externalPublisher = PassthroughSubject<SplashViewData, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.subscriptions = Set<AnyCancellable>()
        setupObservers()
    }
    
}

// MARK: Private
private extension SplashViewModel {
    
    func setupObservers() {
        intenalEvent.sink { [weak self] in
            self?.internalEventHandler($0)
        }.store(in: &subscriptions)
    }
    
    func internalEventHandler(_ event: SplashViewModelInternal) {
        switch event {
            case .data:
                let layout = SplashViewLayout()
                let data = SplashViewData(layout: layout, image: .logo)
                externalPublisher.send(data)
            
            case .exit:
                coordinator?.exit()
        }
    }
    
}

// MARK: - SplashViewModelInternal
enum SplashViewModelInternal {
    case data
    case exit
}
