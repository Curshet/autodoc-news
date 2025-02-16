import UIKit
import Combine

protocol NavigationViewProtocol: UIView {
    var internalEvent: PassthroughSubject<NewsData, Never> { get }
    var externalEvent: AnyPublisher<Void, Never> { get }
}
