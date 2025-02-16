import Foundation
import Combine

protocol NavigationNetworkManagerProtocol {
    var requestEvent: PassthroughSubject<String, Never> { get }
    var responseEvent: AnyPublisher<Result<NewsData, Error>, Never> { get }
}
