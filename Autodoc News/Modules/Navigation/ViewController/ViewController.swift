import UIKit

class NavigationViewController: UIViewController {
    
    private let viewModel: NavigationViewModelProtocol
    private let customView: NavigationViewProtocol
    
    init(viewModel: NavigationViewModelProtocol, customView: NavigationViewProtocol) {
        self.viewModel = viewModel
        self.customView = customView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }

}
