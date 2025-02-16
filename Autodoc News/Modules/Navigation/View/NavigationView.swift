import UIKit
import Combine
import SnapKit

class NavigationView: UIView, NavigationViewProtocol {
    
    let internalEvent: PassthroughSubject<NewsData, Never>
    let externalEvent: AnyPublisher<Void, Never>
    
    private let externalPublisher: PassthroughSubject<Void, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init() {
        self.internalEvent = PassthroughSubject<NewsData, Never>()
        self.externalPublisher = PassthroughSubject<Void, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init(frame: .zero)
        self.backgroundColor = .white
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private
private extension NavigationView {
    
    func setupObservers() {
        internalEvent.sink { [weak self] _ in
            self?.backgroundColor = .systemGreen
        }.store(in: &subscriptions)
    }
    
}
