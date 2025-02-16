import Foundation
import Combine

protocol SplashCoordinatorProtocol {
    var startEvent: PassthroughSubject<Void, Never> { get }
    var exitEvent: AnyPublisher<Void, Never> { get }
}
