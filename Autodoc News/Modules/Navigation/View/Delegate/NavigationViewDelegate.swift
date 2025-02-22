import UIKit
import Combine

class NavigationViewDelegate: NSObject, NavigationViewDelegateProtocol {
    
    let externalEvent: AnyPublisher<Int, Never>
    private let externalPublisher: PassthroughSubject<Int, Never>
    
    override init() {
        self.externalPublisher = PassthroughSubject<Int, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        externalPublisher.send(indexPath.row)
    }
    
}
