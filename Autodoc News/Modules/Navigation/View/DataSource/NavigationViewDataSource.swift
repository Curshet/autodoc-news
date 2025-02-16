import UIKit
import Combine

class NavigationViewDataSource: NSObject, NavigationViewDataSourceProtocol {
    
    let internalEvent: PassthroughSubject<NewsData, Never>
    let externalEvent: AnyPublisher<Void, Never>
    
    private let externalPublisher: PassthroughSubject<Void, Never>
    private var news: [NewsItem]
    private var subscriptions: Set<AnyCancellable>
    
    override init() {
        self.internalEvent = PassthroughSubject<NewsData, Never>()
        self.externalPublisher = PassthroughSubject<Void, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.news = [NewsItem]()
        self.subscriptions = Set<AnyCancellable>()
        super.init()
        setupObservers()
    }
    
    private func setupObservers() {
        internalEvent.sink { [weak self] in
            self?.news = $0.news
        }.store(in: &subscriptions)
    }
    
}

// MARK: Protocol
extension NavigationViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        defaultCell(collectionView, indexPath)
    }
    
}
