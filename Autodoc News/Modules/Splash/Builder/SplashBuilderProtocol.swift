import UIKit

protocol SplashBuilderProtocol {
    var coordinator: SplashCoordinatorProtocol? { get }
    var window: UIWindow? { get }
    var viewController: SplashViewController? { get }
}
