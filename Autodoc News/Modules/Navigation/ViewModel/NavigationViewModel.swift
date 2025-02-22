import Foundation
import Combine

class NavigationViewModel: NavigationViewModelProtocol {
    
    let internalEvent: PassthroughSubject<NavigationViewModelInternal, Never>
    let externalEvent: AnyPublisher<NavigationViewModelExternal, Never>
    
    private weak var coordinator: NavigationCoordinatorRouteProtocol?
    private let networkManager: NavigationNetworkManagerProtocol
    private let storage: StorageProtocol
    private let externalPublisher: PassthroughSubject<NavigationViewModelExternal, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(coordinator: NavigationCoordinatorRouteProtocol, networkManager: NavigationNetworkManagerProtocol, storage: StorageProtocol) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.storage = storage
        self.internalEvent = PassthroughSubject<NavigationViewModelInternal, Never>()
        self.externalPublisher = PassthroughSubject<NavigationViewModelExternal, Never>()
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
                networkManager.requestEvent.send(.data(1))
            
            case .navigationBar:
                break
            
            case .pagination(_):
                break
            
            case .action(let type):
                actionHandler(type)
        }
    }
    
    func actionHandler(_ type: NavigationViewModelAction) {
        switch type {
            case .loadImage(let value):
                networkManager.requestEvent.send(.image(value))
            
            case .select:
                break
        }
    }
    
    func networkResponseHandler(_ event: NavigationNetworkManagerResponse) {
        switch event {
            case .data(let value):
                dataHandler(value)
            
            case .image(let value):
                externalPublisher.send(.image(value))
        }
    }
    
    func dataHandler(_ result: Result<News, Error>) {
        switch result {
            case .success(let value):
                successHandler(value)
            
            case .failure:
                break
        }
    }
    
    func successHandler(_ data: News) {
        let cellLayout = NavigationNewsViewLayout()
        let viewLayout = NavigationViewLayout()
        let news = data.news.map { NewsInfo(layout: cellLayout, title: $0.title, description: "#\($0.id)  |  \(Date.convert(from: $0.publishedDate))") }
        let value = NewsData(layout: viewLayout, news: news, totalCount: data.totalCount)
        externalPublisher.send(.data(value))
    
        for (index, item) in data.news.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let value = NewsImageLink(indexPath: indexPath, link: item.titleImageUrl)
            networkManager.requestEvent.send(.image(value))
        }
    }
    
}

// MARK: - NavigationViewModelInternal
enum NavigationViewModelInternal {
    case data
    case pagination(IndexPath)
    case navigationBar
    case action(NavigationViewModelAction)
}

// MARK: - NavigationViewModelAction
enum NavigationViewModelAction {
    case loadImage(NewsImageLink)
    case select(Int)
}

// MARK: - NavigationViewModelExternal
enum NavigationViewModelExternal {
    case data(NewsData)
    case image(NewsImage)
}
