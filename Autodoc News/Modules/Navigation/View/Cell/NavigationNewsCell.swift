import UIKit

class NavigationNewsCell: UICollectionViewCell, NavigationNewsCellProtocol {
    
    private var subview: NavigationNewsViewProtocol!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subview?.reset()
    }
    
    func inject(view: NavigationNewsViewProtocol) {
        guard subviews.isEmpty else { return }
        subview = view
        addSubview(subview)
    }
    
    func configure(_ data: NewsInfo) {
        subview.configure(data)
    }
    
}
