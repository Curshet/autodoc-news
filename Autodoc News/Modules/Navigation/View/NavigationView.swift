import UIKit

class NavigationView: UIView, NavigationViewProtocol {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
