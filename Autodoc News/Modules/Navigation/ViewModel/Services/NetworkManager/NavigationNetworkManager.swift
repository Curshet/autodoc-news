import Foundation
import Combine

class NavigationNetworkManager: NSObject, NavigationNetworkManagerProtocol {

    let requestEvent: PassthroughSubject<String, Never>
    let responseEvent: AnyPublisher<Result<NewsData, Error>, Never>
    
    private let session: URLSessionProtocol
    private let decoder: JSONDecoderProtocol
    private let responsePublisher: PassthroughSubject<Result<NewsData, Error>, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(session: URLSessionProtocol, decoder: JSONDecoderProtocol) {
        self.session = session
        self.decoder = decoder
        self.requestEvent = PassthroughSubject<String, Never>()
        self.responsePublisher = PassthroughSubject<Result<NewsData, Error>, Never>()
        self.responseEvent = AnyPublisher(responsePublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init()
        setupObservers()
    }
    
}

// MARK: Private
private extension NavigationNetworkManager {
    
    func setupObservers() {
        requestEvent.sink { [weak self] in
            self?.request($0)
        }.store(in: &subscriptions)
    }
    
    func request(_ string: String) {
        guard !string.isEmpty else {
            logger.print("Incorrect value of URL for empty string")
            return
        }
        
        guard let url = URL(string: string) else {
            logger.print("Incorrect value of URL for string: \(string)")
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let error else {
                self?.dataHandler(data)
                return
            }
            
            self?.logger.print("Data request for URL: \(string) ended with error: \(error)")
            self?.responsePublisher.send(.failure(error))
        }.resume()
    }
    
    func dataHandler(_ data: Data?) {
        guard let data else {
            let error = NSError()
            logger.print("Server data is empty")
            responsePublisher.send(.failure(error))
            return
        }
        
        do {
            let value = try decoder.decode(NewsData.self, from: data)
            responsePublisher.send(.success(value))
        } catch {
            logger.print("Data decoding ended with error: \(error)")
            responsePublisher.send(.failure(error))
        }
    }
    
}
