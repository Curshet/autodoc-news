import UIKit
import Combine
import SnapKit

class SplashView: UIView, SplashViewProtocol {
    
    let internalEvent: PassthroughSubject<SplashViewData, Never>
    let externalEvent: AnyPublisher<Void, Never>
    
    private let imageView: UIImageView
    private let externalPublisher: PassthroughSubject<Void, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(imageView: UIImageView) {
        self.imageView = imageView
        self.internalEvent = PassthroughSubject<SplashViewData, Never>()
        self.externalPublisher = PassthroughSubject<Void, Never>()
        self.externalEvent = AnyPublisher(externalPublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init(frame: .zero)
        setupConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private
private extension SplashView {
    
    func setupConfiguration() {
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        setupObservers()
    }
    
    func setupObservers() {
        internalEvent.sink { [weak self] in
            self?.setupLayout($0)
            self?.setupConstraints($0)
            self?.animate($0)
            
        }.store(in: &subscriptions)
    }
    
    func setupLayout(_ data: SplashViewData) {
        imageView.image = data.image
        backgroundColor = data.layout.backgroundColor
    }
    
    func setupConstraints(_ data: SplashViewData) {
        guard imageView.constraints.isEmpty else { return }
        
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(data.layout.size.width)
            $0.height.equalTo(data.layout.size.height)
        }
    }
    
    func animate(_ data: SplashViewData) {
        Self.animate(withDuration: data.layout.duration) {
            self.imageView.transform = data.layout.transform
        } completion: { _ in
            self.externalPublisher.send()
        }
    }
    
}

// MARK: - SplashViewLayout
struct SplashViewLayout {
    let backgroundColor = UIColor.white
    let size = CGSize(width: 350, height: 150)
    let duration = 2.5
    let transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
}
