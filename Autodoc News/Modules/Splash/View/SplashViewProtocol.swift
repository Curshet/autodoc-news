import UIKit
import Combine

protocol SplashViewProtocol: UIView {
    var internalEvent: PassthroughSubject<SplashViewData, Never> { get }
    var externalEvent: AnyPublisher<Void, Never> { get }
}
