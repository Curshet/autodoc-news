import UIKit

class NavigationBuilder: Builder {
    
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
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    
}

// MARK: NavigationBuilderProtocol
extension NavigationBuilder: NavigationBuilderProtocol {
    
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
        
        guard let fileManager = injector.resolve(FileManager.self, from: .application) else {
            return error(of: FileManager.self)
        }
        
        guard let coordinator = injector.resolve(NavigationCoordinator.self, from: .navigation) else {
            return error(of: NavigationCoordinator.self)
        }
        
        let networkManager = NavigationNetworkManager(session: session, decoder: decoder)
        let storage = Storage(fileManager: fileManager)
        let viewModel = NavigationViewModel(coordinator: coordinator, networkManager: networkManager, storage: storage)
        let dataSource = NavigationViewDataSource(builder: self)
        let delegate = NavigationViewDelegate()
        let view = NavigationView(dataSource: dataSource, delegate: delegate, layout: layout)
        view.dataSource = dataSource
        view.delegate = delegate
        let viewController = NavigationViewController(viewModel: viewModel, customView: view)
        return viewController
    }
    
}

// MARK: NavigationBuilderCellProtocol
extension NavigationBuilder: NavigationBuilderCellProtocol {
    
    func newsCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ data: NewsInfo) -> NavigationNewsCellProtocol? {
        let titleLabel = UILabel()
        let textLabel = UILabel()
        let imageView = UIImageView()
        let indicatorView = UIActivityIndicatorView(style: .medium)
        let view = NavigationNewsView(titleLabel: titleLabel, textLabel: textLabel, imageView: imageView, indicatorView: indicatorView)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavigationNewsCell.typeName, for: indexPath) as? NavigationNewsCell
        cell?.inject(view: view)
        cell?.configure(data)
        return cell
    }
    
}
