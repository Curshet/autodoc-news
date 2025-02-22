import UIKit

protocol NavigationBuilderCellProtocol: AnyObject {
    func newsCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ data: NewsInfo) -> NavigationNewsCellProtocol?
}
