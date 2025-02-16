import UIKit
import Combine

class SplashViewController: UIViewController {
    
    private let viewModel: SplashViewModelProtocol
    private let customView: SplashViewProtocol
    private var subscriptions: Set<AnyCancellable>
    
    init(viewModel: SplashViewModelProtocol, view: SplashViewProtocol) {
        self.viewModel = viewModel
        self.customView = view
        self.subscriptions = Set<AnyCancellable>()
        super.init(nibName: nil, bundle: nil)
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.intenalEvent.send(.data)
    }
    
    private func setupObservers() {
        viewModel.externalEvent.sink { [weak self] in
            self?.customView.internalEvent.send($0)
        }.store(in: &subscriptions)
        
        customView.externalEvent.sink { [weak self] in
            self?.viewModel.intenalEvent.send(.exit)
        }.store(in: &subscriptions)
    }
    
}
