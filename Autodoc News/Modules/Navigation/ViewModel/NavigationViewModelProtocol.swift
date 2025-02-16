import Foundation
import Combine

protocol NavigationViewModelProtocol {
    var internalEvent: PassthroughSubject<NavigationViewModelInternal, Never> { get }
    var externalEvent: AnyPublisher<NewsData, Never> { get }
}
