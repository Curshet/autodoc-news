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
    
    var decoder: JSONDecoderProtocol {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        return layout
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
        guard let session = injector.resolve(URLSession.self, from: .application) else {
            return error(of: URLSession.self)
        }
        
        guard let coordinator = injector.resolve(NavigationCoordinator.self, from: .navigation) else {
            return error(of: NavigationCoordinator.self)
        }
        
        let networkManager = NavigationNetworkManager(session: session, decoder: decoder)
        let viewModel = NavigationViewModel(coordinator: coordinator, networkManager: networkManager)
        let dataSource = NavigationViewDataSource()
        let delegate = NavigationViewDelegate()
        let view = NavigationView(dataSource: dataSource, delegate: delegate, layout: layout)
        let viewController = NavigationViewController(viewModel: viewModel, customView: view)
        return viewController
    }
    
}
