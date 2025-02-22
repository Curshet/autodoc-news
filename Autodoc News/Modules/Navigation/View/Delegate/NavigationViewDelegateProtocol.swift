import UIKit
import Combine

protocol NavigationViewDelegateProtocol: UICollectionViewDelegateFlowLayout {
    var externalEvent: AnyPublisher<Int, Never> { get }
}
