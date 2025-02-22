import UIKit
import Combine

class NavigationNetworkManager: NSObject, NavigationNetworkManagerProtocol {

    let requestEvent: PassthroughSubject<NavigationNetworkManagerRequest, Never>
    let responseEvent: AnyPublisher<NavigationNetworkManagerResponse, Never>
    
    private let session: URLSessionProtocol
    private let decoder: JSONDecoderProtocol
    private let responsePublisher: PassthroughSubject<NavigationNetworkManagerResponse, Never>
    private var subscriptions: Set<AnyCancellable>
    
    init(session: URLSessionProtocol, decoder: JSONDecoderProtocol) {
        self.session = session
        self.decoder = decoder
        self.requestEvent = PassthroughSubject<NavigationNetworkManagerRequest, Never>()
        self.responsePublisher = PassthroughSubject<NavigationNetworkManagerResponse, Never>()
        self.responseEvent = AnyPublisher(responsePublisher)
        self.subscriptions = Set<AnyCancellable>()
        super.init()
        setupObservers()
    }
    
}

// MARK: Private
private extension NavigationNetworkManager {
    
    func setupObservers() {
        requestEvent.sink { [weak self] type in
            Task(priority: .utility) {
                await self?.requestHandler(type)
            }
        }.store(in: &subscriptions)
    }
    
    func requestHandler(_ type: NavigationNetworkManagerRequest) async {
        switch type {
            case .data(let page):
                await dataRequest(page)
            
            case .image(let value):
                await imageRequest(value)
        }
    }
    
    func dataRequest(_ page: Int) async {
        let path = "https://webapi.autodoc.ru/api/news/\(page)/15"
        
        guard let url = url(path) else { return }
        
        logger.print("Starting data request for URL: \(path)")
        
        do {
            let (data, _) = try await self.session.data(from: url)
            await dataHandler(data)
        } catch {
            logger.print("Data request is ended with error: \(error.localizedDescription)")
            responsePublisher.send(.data(.failure(error)))
        }
    }
    
    func dataHandler(_ data: Data) async {
        guard !data.isEmpty else {
            let error = NSError.system
            logger.print("Server data is empty")
            responsePublisher.send(.data(.failure(error)))
            return
        }
        
        do {
            let value = try decoder.decode(News.self, from: data)
            logger.print("Server data decoding is successfully ended")
            responsePublisher.send(.data(.success(value)))
        } catch {
            logger.print("Server data decoding is ended with error: \(error.localizedDescription)")
            responsePublisher.send(.data(.failure(error)))
        }
    }
    
    func imageRequest(_ value: NewsImageLink) async {
        guard let url = url(value.link) else { return }
        
        logger.print("Starting image request for URL: \(value.link)")
        
        do {
            let (data, _) = try await self.session.data(from: url)
            let result = UIImage(data: data)
            let jpegData = result?.jpegData(compressionQuality: 0.2)
            guard let jpegData else { throw NSError.system }
            let image = UIImage(data: jpegData)
            let value = NewsImage(indexPath: value.indexPath, image: image)
            logger.print("Image decoding is successfully ended for indexPath: \(value.indexPath)")
            responsePublisher.send(.image(value))
        } catch {
            logger.print("Image decoding is ended with error: \(error.localizedDescription) for indexPath: \(value.indexPath)")
            let image = UIImage.default
            let value = NewsImage(indexPath: value.indexPath, image: image)
            responsePublisher.send(.image(value))
        }
    }
    
    func url(_ path: String) -> URL? {
        guard !path.isEmpty else {
            logger.print("Server request error of empty URL")
            return nil
        }
        
        guard let url = URL(string: path) else {
            logger.print("Incorrect value of URL for path: \(path)")
            return nil
        }
        
        return url
    }
    
}

// MARK: - NavigationNetworkManagerRequest
enum NavigationNetworkManagerRequest {
    case data(Int)
    case image(NewsImageLink)
}

// MARK: - NavigationNetworkManagerResponse
enum NavigationNetworkManagerResponse {
    case data(Result<News, Error>)
    case image(NewsImage)
}
