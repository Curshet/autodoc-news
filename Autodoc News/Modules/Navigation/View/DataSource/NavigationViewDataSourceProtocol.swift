import UIKit
import Combine

protocol NavigationViewDataSourceProtocol: UICollectionViewDataSource {
    var externalEvent: AnyPublisher<NewsImageLink, Never> { get }
    func configure(_ data: NewsData)
    func update(_ data: NewsImage)
}
