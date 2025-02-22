import UIKit
import Combine

class NavigationViewDataSource: NSObject, NavigationViewDataSourceProtocol {
    
    let externalEvent: AnyPublisher<NewsImageLink, Never>
    
    private weak var builder: NavigationBuilderCellProtocol?
    private let mutex: NSLock
    private let externalPublisher: PassthroughSubject<NewsImageLink, Never>
    private var news: [NewsInfo]
    
    init(builder: NavigationBuilderCellProtocol) {
        self.builder = builder
        self.mutex = NSLock()
        self.externalPublisher = PassthroughSubject<NewsImageLink, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.news = [NewsInfo]()
        super.init()
    }
    
    func configure(_ data: NewsData) {
        mutex.lock()
        news += data.news
        mutex.unlock()
    }
    
    func update(_ data: NewsImage) {
        mutex.lock()
        news[data.indexPath.row].image = data.image
        mutex.unlock()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        builder?.newsCell(collectionView, indexPath, news[indexPath.row]) ?? defaultCell(collectionView, indexPath)
    }
    
}
