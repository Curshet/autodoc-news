import Foundation
import Combine

protocol NavigationNetworkManagerProtocol {
    var requestEvent: PassthroughSubject<NavigationNetworkManagerRequest, Never> { get }
    var responseEvent: AnyPublisher<NavigationNetworkManagerResponse, Never> { get }
}
