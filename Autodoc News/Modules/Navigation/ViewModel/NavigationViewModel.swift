import Foundation

class NavigationViewModel: NavigationViewModelProtocol {
    
    private weak var coorinator: NavigationCoordinatorRouteProtocol?
    
    init(coorinator: NavigationCoordinatorRouteProtocol?) {
        self.coorinator = coorinator
    }
    
}
