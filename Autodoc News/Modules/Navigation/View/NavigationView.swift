import UIKit
import Combine

class NavigationView: UICollectionView, NavigationViewProtocol {
    
    let internalEvent: PassthroughSubject<NavigationViewModelExternal, Never>
    let externalEvent: AnyPublisher<NavigationViewModelAction, Never>
    
    private let customDataSource: NavigationViewDataSourceProtocol
    private let customDelegate: NavigationViewDelegateProtocol
    private let layout: UICollectionViewFlowLayout
    private let externalPublisher: PassthroughSubject<NavigationViewModelAction, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(dataSource: NavigationViewDataSourceProtocol, delegate: NavigationViewDelegateProtocol, layout: UICollectionViewFlowLayout) {
        self.customDataSource = dataSource
        self.customDelegate = delegate
        self.layout = layout
        self.internalEvent = PassthroughSubject<NavigationViewModelExternal, Never>()
        self.externalPublisher = PassthroughSubject<NavigationViewModelAction, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init(frame: .zero, collectionViewLayout: layout)
        startConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private
private extension NavigationView {
    
    func startConfiguration() {
        setupConfiguration()
        setupObservers()
    }
    
    func setupConfiguration() {
        alwaysBounceVertical = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.typeName)
        register(NavigationNewsCell.self, forCellWithReuseIdentifier: NavigationNewsCell.typeName)
    }
    
    func setupObservers() {
        internalEvent.sink { [weak self] in
            self?.internalEventHandler($0)
        }.store(in: &subscriptions)
        
        customDataSource.externalEvent.sink { [weak self] in
            self?.externalPublisher.send(.loadImage($0))
        }.store(in: &subscriptions)
        
        customDelegate.externalEvent.sink { [weak self] in
            self?.externalPublisher.send(.select($0))
        }.store(in: &subscriptions)
    }
    
    func internalEventHandler(_ event: NavigationViewModelExternal) {
        switch event {
            case .data(let value):
                layout.minimumLineSpacing = value.layout.minimumLineSpacing
                contentInset = value.layout.contentInset
                customDataSource.configure(value)

            case .image(let value):
                customDataSource.update(value)
        }
        
        reloadData()
    }
    
}

// MARK: - NavigationViewLayout
struct NavigationViewLayout {
    let minimumLineSpacing = CGFloat(20)
    let contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 25, right: 0)
}
