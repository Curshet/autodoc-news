import Foundation

final class AppCoordinator: AppCoordinatorProtocol {
    
    private let builder: AppBuilderProtocol
    
    init(builder: AppBuilderProtocol) {
        self.builder = builder
    }
    
    func start() -> Bool {
        true
    }
    
}
