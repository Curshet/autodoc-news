import Foundation

protocol AppBuilderProtocol {
    var appCoordinator: AppCoordinatorProtocol? { get }
    var splashCoordinator: SplashCoordinatorProtocol? { get }
    var navigationCoordinator: NavigationCoordinatorProtocol? { get }
}
