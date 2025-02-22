import UIKit
import Combine

class NavigationViewController: UIViewController {
    
    private let viewModel: NavigationViewModelProtocol
    private let customView: NavigationViewProtocol
    private var subscriptions: Set<AnyCancellable>
    
    init(viewModel: NavigationViewModelProtocol, customView: NavigationViewProtocol) {
        self.viewModel = viewModel
        self.customView = customView
        self.subscriptions = Set<AnyCancellable>()
        super.init(nibName: nil, bundle: nil)
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupObservers() {
        viewModel.externalEvent.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.customView.internalEvent.send($0)
        }.store(in: &subscriptions)
        
        customView.externalEvent.sink { [weak self] in
            self?.viewModel.internalEvent.send(.action($0))
        }.store(in: &subscriptions)
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.internalEvent.send(.data)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.internalEvent.send(.navigationBar)
    }

}
