import Foundation
import Combine

protocol SplashViewModelProtocol {
    var intenalEvent: PassthroughSubject<SplashViewModelInternal, Never> { get }
    var externalEvent: AnyPublisher<SplashViewData, Never> { get }
}
