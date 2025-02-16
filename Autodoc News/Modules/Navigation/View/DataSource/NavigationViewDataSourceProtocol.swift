import UIKit
import Combine

protocol NavigationViewDataSourceProtocol: UICollectionViewDataSource {
    var internalEvent: PassthroughSubject<NewsData, Never> { get }
    var externalEvent: AnyPublisher<Void, Never> { get }
}
