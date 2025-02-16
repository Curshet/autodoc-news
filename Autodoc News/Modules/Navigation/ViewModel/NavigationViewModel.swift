import Foundation
import Combine

class NavigationViewModel: NavigationViewModelProtocol {
    
    let internalEvent: PassthroughSubject<NavigationViewModelInternal, Never>
    let externalEvent: AnyPublisher<NewsData, Never>
    
    private weak var coordinator: NavigationCoordinatorRouteProtocol?
    private let networkManager: NavigationNetworkManagerProtocol
    private let externalPublisher: PassthroughSubject<NewsData, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(coordinator: NavigationCoordinatorRouteProtocol?, networkManager: NavigationNetworkManagerProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.internalEvent = PassthroughSubject<NavigationViewModelInternal, Never>()
        self.externalPublisher = PassthroughSubject<NewsData, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.subscriptions = Set<AnyCancellable>()
        setupObservers()
    }
    
}

// MARK: Private
private extension NavigationViewModel {
    
    func setupObservers() {
        internalEvent.sink { [weak self] in
            self?.internalEventHandler($0)
        }.store(in: &subscriptions)
        
        networkManager.responseEvent.sink { [weak self] in
            self?.networkResponseHandler($0)
        }.store(in: &subscriptions)
    }
    
    func internalEventHandler(_ event: NavigationViewModelInternal) {
        switch event {
            case .data:
                let string = "https://webapi.autodoc.ru/api/news/1/15"
                networkManager.requestEvent.send(string)
            
            case .navigationBar:
                break
        }
    }
    
    func networkResponseHandler(_ result: Result<NewsData, Error>) {
        switch result {
            case .success(let data):
                externalPublisher.send(data)
            
            case .failure(_):
                break
        }
    }
    
}

// MARK: - NavigationViewModelInternal
enum NavigationViewModelInternal {
    case data
    case navigationBar
}
