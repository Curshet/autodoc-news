import UIKit
import Combine

protocol NavigationViewProtocol: UIView {
    var internalEvent: PassthroughSubject<NavigationViewModelExternal, Never> { get }
    var externalEvent: AnyPublisher<NavigationViewModelAction, Never> { get }
}
