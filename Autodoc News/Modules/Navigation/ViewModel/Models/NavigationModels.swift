import UIKit

// MARK: - News
struct News: Decodable {
    let news: [NewsItem]
    let totalCount: Int
    let page: Int?
}

// MARK: - NewsItem
struct NewsItem: Decodable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
    let image: Data?
}

// MARK: - NewsData
struct NewsData {
    let layout: NavigationViewLayout
    let news: [NewsInfo]
    let totalCount: Int
}

// MARK: - NewsInfo
struct NewsInfo {
    let layout: NavigationNewsViewLayout
    let title: String
    let description: String
    var image: UIImage?
}

// MARK: - NewsImageLink
struct NewsImageLink {
    let indexPath: IndexPath
    let link: String
}

// MARK: - NewsImage
struct NewsImage {
    let indexPath: IndexPath
    let image: UIImage?
}
