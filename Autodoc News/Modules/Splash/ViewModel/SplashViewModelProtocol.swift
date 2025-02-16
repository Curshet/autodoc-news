import Foundation
import Combine

protocol SplashViewModelProtocol {
    var intenalEvent: PassthroughSubject<SplashViewModelInternalEvent, Never> { get }
    var externalEvent: AnyPublisher<SplashViewData, Never> { get }
}
