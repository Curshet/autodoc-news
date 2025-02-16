import UIKit
import Combine
import SnapKit

class NavigationView: UICollectionView, NavigationViewProtocol {
    
    let internalEvent: PassthroughSubject<NewsData, Never>
    let externalEvent: AnyPublisher<Void, Never>
    
    private let customDataSource: NavigationViewDataSourceProtocol
    private let customDelegate: NavigationViewDelegateProtocol
    private let layout: UICollectionViewFlowLayout
    private let externalPublisher: PassthroughSubject<Void, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(dataSource: NavigationViewDataSourceProtocol, delegate: NavigationViewDelegateProtocol, layout: UICollectionViewFlowLayout) {
        self.customDataSource = dataSource
        self.customDelegate = delegate
        self.layout = layout
        self.internalEvent = PassthroughSubject<NewsData, Never>()
        self.externalPublisher = PassthroughSubject<Void, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = customDataSource
        self.delegate = customDelegate
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private
private extension NavigationView {
    
    func setupObservers() {
        internalEvent.sink { [weak self] in
            self?.backgroundColor = .systemGreen
            self?.customDataSource.internalEvent.send($0)
        }.store(in: &subscriptions)
    }
    
}
