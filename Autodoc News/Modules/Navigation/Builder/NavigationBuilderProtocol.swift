import UIKit

protocol NavigationBuilderProtocol {
    var coordinator: NavigationCoordinatorProtocol? { get }
    var window: UIWindow? { get }
    var viewController: NavigationViewController? { get }
}
